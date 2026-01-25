require "sorbet-runtime"
require_relative "validation_error"

module SorbetSchemaEnforcer
  def self.included(base)
    base.extend(ClassMethods)
    base.prepend(InstanceMethods)
  end

  module ClassMethods
    def validate_all(args)
      errors = ValidationError.new("Validation failed")
      return [errors, args] unless args.is_a?(Hash)

      known_keys = props.keys.map(&:to_s)
      args.keys.map(&:to_s).each do |key|
        next if known_keys.include?(key)
        errors.add(key: key, value: "is not permitted")
      end

      coerced = args.dup
      props.each do |name, prop|
        key = name.to_s
        value = args.key?(name) ? args[name] : args[key]

        if value.nil?
          errors.add(key: key, value: "is required") unless prop[:fully_optional]
          next
        end

        coerced_value = validate_and_coerce(errors, key, prop[:type], prop[:type_object], value)
        coerced[name] = coerced_value if args.key?(name)
        coerced[key] = coerced_value if args.key?(key)
      end

      [errors, coerced]
    end

    def validate_and_coerce(errors, key, type, type_object, value)
      if type.is_a?(Class) && type < T::Struct
        return value if value.is_a?(type)

        if value.is_a?(Hash)
          before = errors.errors.dup
          coerced = validate_struct_hash(errors, key, type, value)
          return type.new(coerced) if before == errors.errors
          return value
        end

        errors.add(key: key, value: "must be a #{type} (got #{value.class})")
        return value
      end

      if type_object.is_a?(T::Types::TypedArray)
        unless value.is_a?(Array)
          errors.add(key: key, value: "must be an Array (got #{value.class})")
          return value
        end

        element_type = type_object.type
        coerced = value.dup
        value.each_with_index do |item, index|
          item_key = "#{key}[#{index}]"
          if element_type.is_a?(Class) && element_type < T::Struct
            if item.is_a?(Hash)
              before = errors.errors.dup
              validate_struct_hash(errors, item_key, element_type, item)
              coerced[index] = item if before != errors.errors
              next
            end

            unless item.is_a?(element_type)
              errors.add(key: item_key, value: "is invalid")
            end
            next
          end

          if element_type.respond_to?(:valid?) && !element_type.valid?(item)
            errors.add(key: item_key, value: "is invalid")
          end
        end
        return coerced
      end

      if type_object.respond_to?(:valid?) && !type_object.valid?(value)
        errors.add(key: key, value: "is invalid")
      end

      value
    end

    def validate_struct_hash(errors, key, struct_class, hash)
      known_keys = struct_class.props.keys.map(&:to_s)
      hash.keys.map(&:to_s).each do |k|
        next if known_keys.include?(k)
        errors.add(key: "#{key}.#{k}", value: "is not permitted")
      end

      coerced = hash.dup
      struct_class.props.each do |name, prop|
        prop_key = name.to_s
        value = hash.key?(name) ? hash[name] : hash[prop_key]
        full_key = "#{key}.#{prop_key}"

        if value.nil?
          errors.add(key: full_key, value: "is required") unless prop[:fully_optional]
          next
        end

        coerced_value = validate_and_coerce(errors, full_key, prop[:type], prop[:type_object], value)
        coerced[name] = coerced_value if hash.key?(name)
        coerced[prop_key] = coerced_value if hash.key?(prop_key)
      end

      coerced
    end
  end

  module InstanceMethods
    def initialize(args)
      errors, coerced = self.class.validate_all(args)
      raise errors unless errors.errors.empty?

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
