require "sorbet-runtime"
require_relative "validation_error"

module SorbetSchemaEnforcer
  def self.struct_cache_for(klass)
    klass.instance_variable_get(:@_sorbet_schema_cache) ||
      klass.instance_variable_set(:@_sorbet_schema_cache, begin
        props_list = klass.props.map do |name, prop|
          {
            name: name,
            key: name.to_s,
            type: prop[:type],
            type_object: prop[:type_object],
            fully_optional: prop[:fully_optional]
          }
        end
        { known_keys: props_list.map { |p| p[:key] }, props: props_list }
      end)
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.prepend(InstanceMethods)
  end

  module ClassMethods
    def add_error(errors, key, value)
      errors ||= ValidationError.new("Validation failed")
      errors.add(key: key, value: value)
      errors
    end

    def error_count(errors)
      return 0 unless errors
      errors.errors.values.sum(&:size)
    end

    def validate_all(args)
      errors = nil
      return [errors, args] unless args.is_a?(Hash)

      cache = SorbetSchemaEnforcer.struct_cache_for(self)
      known_keys = cache[:known_keys]
      args.keys.map(&:to_s).each do |key|
        next if known_keys.include?(key)
        errors = add_error(errors, key, "is not permitted")
      end

      coerced = args.dup
      cache[:props].each do |entry|
        name = entry[:name]
        key = entry[:key]
        value = args.key?(name) ? args[name] : args[key]

        if value.nil?
          errors = add_error(errors, key, "is required") unless entry[:fully_optional]
          next
        end

        errors, coerced_value = validate_and_coerce(errors, key, entry[:type], entry[:type_object], value)
        coerced[name] = coerced_value if args.key?(name)
        coerced[key] = coerced_value if args.key?(key)
      end

      [errors, coerced]
    end

    def validate_and_coerce(errors, key, type, type_object, value)
      if type.is_a?(Class) && type < T::Struct
        return [errors, value] if value.is_a?(type)

        if value.is_a?(Hash)
          before_count = error_count(errors)
          errors, coerced = validate_struct_hash(errors, key, type, value)
          return [errors, type.new(coerced)] if error_count(errors) == before_count
          return [errors, value]
        end

        errors = add_error(errors, key, "must be a #{type} (got #{value.class})")
        return [errors, value]
      end

      if type_object.is_a?(T::Types::TypedArray)
        unless value.is_a?(Array)
          errors = add_error(errors, key, "must be an Array (got #{value.class})")
          return [errors, value]
        end

        element_type = type_object.type
        coerced = value.dup
        value.each_with_index do |item, index|
          item_key = "#{key}[#{index}]"
          if element_type.is_a?(Class) && element_type < T::Struct
            if item.is_a?(Hash)
              before_count = error_count(errors)
              errors, nested_coerced = validate_struct_hash(errors, item_key, element_type, item)
              if error_count(errors) == before_count
                coerced[index] = element_type.new(nested_coerced)
              end
              next
            end

            unless item.is_a?(element_type)
              errors = add_error(errors, item_key, "is invalid")
            end
            next
          end

          if element_type.respond_to?(:valid?) && !element_type.valid?(item)
            errors = add_error(errors, item_key, "is invalid")
          end
        end
        return [errors, coerced]
      end

      if type_object.respond_to?(:valid?) && !type_object.valid?(value)
        errors = add_error(errors, key, "is invalid")
      end

      [errors, value]
    end

    def validate_struct_hash(errors, key, struct_class, hash)
      cache = SorbetSchemaEnforcer.struct_cache_for(struct_class)
      known_keys = cache[:known_keys]
      hash.keys.map(&:to_s).each do |k|
        next if known_keys.include?(k)
        errors = add_error(errors, "#{key}.#{k}", "is not permitted")
      end

      coerced = hash.dup
      cache[:props].each do |entry|
        name = entry[:name]
        prop_key = entry[:key]
        value = hash.key?(name) ? hash[name] : hash[prop_key]
        full_key = "#{key}.#{prop_key}"

        if value.nil?
          errors = add_error(errors, full_key, "is required") unless entry[:fully_optional]
          next
        end

        errors, coerced_value = validate_and_coerce(errors, full_key, entry[:type], entry[:type_object], value)
        coerced[name] = coerced_value if hash.key?(name)
        coerced[prop_key] = coerced_value if hash.key?(prop_key)
      end

      [errors, coerced]
    end
  end

  module InstanceMethods
    def initialize(args)
      errors, coerced = self.class.validate_all(args)
      raise errors if errors && !errors.errors.empty?

      super(coerced)
    end
  end
end

class SorbetStructMessageDetails < T::Struct
  const :messages, T::Array[String]
end

class SorbetStructMessage < T::Struct
  include SorbetSchemaEnforcer

  const :error, String
  const :message, String
  const :details, SorbetStructMessageDetails
end
