require "dry-struct"
require_relative "validation_error"
require_relative "types"

module DrySchemaEnforcer
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def schema_cache
      @schema_cache ||= begin
        schema = self.schema.type
        schema.keys.map do |key|
          {
            name: key.name,
            string_name: key.name.to_s,
            required: key.required?,
            type: key.type
          }
        end
      end
    end

    def new(args = {})
      errors, coerced = validate_all(args)
      raise errors unless errors.errors.empty?

      super(coerced)
    end

    def validate_all(args)
      errors = ValidationError.new("Validation failed")
      return [errors, args] unless args.is_a?(Hash)

      coerced = args.dup
      schema_cache.each do |entry|
        name = entry[:name]
        string_name = entry[:string_name]
        value = if args.key?(name)
          args[name]
        else
          args[string_name]
        end

        if value.nil?
          errors.add(key: string_name, value: "is required") if entry[:required]
          next
        end

        coerced_value = validate_and_coerce(errors, string_name, entry[:type], value)
        coerced[name] = coerced_value if args.key?(name)
        coerced[string_name] = coerced_value if args.key?(string_name)
      end

      [errors, coerced]
    end

    def validate_and_coerce(errors, key, type, value)
      nominal = type.respond_to?(:type) ? type.type : type
      primitive = nominal.respond_to?(:primitive) ? nominal.primitive : nil

      if primitive && primitive < Dry::Struct
        return value if value.is_a?(primitive)

        if value.is_a?(Hash) && primitive.respond_to?(:validate_all)
          nested_errors, nested_coerced = primitive.validate_all(value)
          if nested_errors && !nested_errors.errors.empty?
            nested_errors.errors.each do |nested_key, messages|
              messages.each { |msg| errors.add(key: "#{key}.#{nested_key}", value: msg) }
            end
            return value
          end
          return primitive.new(nested_coerced)
        end

        errors.add(key: key, value: "must be a #{primitive} (got #{value.class})")
        return value
      end

      if primitive == Array && nominal.respond_to?(:member)
        unless value.is_a?(Array)
          errors.add(key: key, value: "must be an Array (got #{value.class})")
          return value
        end

        member_type = nominal.member
        coerced = value.dup
        value.each_with_index do |item, index|
          item_key = "#{key}[#{index}]"
          if member_type.respond_to?(:type) && member_type.type.respond_to?(:primitive) && member_type.type.primitive < Dry::Struct
            nested_class = member_type.type.primitive
            if item.is_a?(Hash) && nested_class.respond_to?(:validate_all)
              nested_errors, nested_coerced = nested_class.validate_all(item)
              if nested_errors && !nested_errors.errors.empty?
                nested_errors.errors.each do |nested_key, messages|
                  messages.each { |msg| errors.add(key: "#{item_key}.#{nested_key}", value: msg) }
                end
              else
                coerced[index] = nested_class.new(nested_coerced)
              end
              next
            end
          end

          errors.add(key: item_key, value: "is invalid") unless member_type.valid?(item)
        end
        return coerced
      end

      errors.add(key: key, value: "is invalid") unless type.valid?(value)
      value
    end
  end
end

class DryStructMessageDetails < Dry::Struct
  include DrySchemaEnforcer

  attribute :messages, Types::Strict::Array.of(Types::Strict::String)
end

class DryStructMessage < Dry::Struct
  include DrySchemaEnforcer

  attribute :error, Types::Strict::String
  attribute :message, Types::Strict::String
  attribute :details, Types::Instance(DryStructMessageDetails)
end
