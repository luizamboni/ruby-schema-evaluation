require "dry-struct"
require_relative "validation_error"
require_relative "types"

module DrySchemaEnforcer
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def add_error(errors, key, value)
      errors ||= Hash.new { |hash, k| hash[k] = [] }
      errors[key] << value
      errors
    end

    def merge_errors(errors, prefix, nested_errors)
      return errors unless nested_errors && !nested_errors.empty?
      errors ||= Hash.new { |hash, k| hash[k] = [] }
      nested_errors.each do |nested_key, messages|
        messages.each { |msg| errors["#{prefix}.#{nested_key}"] << msg }
      end
      errors
    end

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
      if errors && !errors.empty?
        error = ValidationError.new("Validation failed")
        error.errors = errors
        raise error
      end

      super(coerced)
    end

    def validate_all(args)
      errors = nil
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
          errors = add_error(errors, string_name, "is required") if entry[:required]
          next
        end

        errors, coerced_value = validate_and_coerce(errors, string_name, entry[:type], value)
        coerced[name] = coerced_value if args.key?(name)
        coerced[string_name] = coerced_value if args.key?(string_name)
      end

      [errors, coerced]
    end

    def validate_and_coerce(errors, key, type, value)
      nominal = type.respond_to?(:type) ? type.type : type
      primitive = nominal.respond_to?(:primitive) ? nominal.primitive : nil

      if primitive && primitive < Dry::Struct
        return [errors, value] if value.is_a?(primitive)

        if value.is_a?(Hash) && primitive.respond_to?(:validate_all)
          nested_errors, nested_coerced = primitive.validate_all(value)
          if nested_errors && !nested_errors.empty?
            errors = merge_errors(errors, key, nested_errors)
            return [errors, value]
          end
          return [errors, primitive.new(nested_coerced)]
        end

        errors = add_error(errors, key, "must be a #{primitive} (got #{value.class})")
        return [errors, value]
      end

      if primitive == Array && nominal.respond_to?(:member)
        unless value.is_a?(Array)
          errors = add_error(errors, key, "must be an Array (got #{value.class})")
          return [errors, value]
        end

        member_type = nominal.member
        coerced = value.dup
        value.each_with_index do |item, index|
          item_key = "#{key}[#{index}]"
          if member_type.respond_to?(:type) && member_type.type.respond_to?(:primitive) && member_type.type.primitive < Dry::Struct
            nested_class = member_type.type.primitive
            if item.is_a?(Hash) && nested_class.respond_to?(:validate_all)
              nested_errors, nested_coerced = nested_class.validate_all(item)
              if nested_errors && !nested_errors.empty?
                errors = merge_errors(errors, item_key, nested_errors)
              else
                coerced[index] = nested_class.new(nested_coerced)
              end
              next
            end
          end

          errors = add_error(errors, item_key, "is invalid") unless member_type.valid?(item)
        end
        return [errors, coerced]
      end

      errors = add_error(errors, key, "is invalid") unless type.valid?(value)
      [errors, value]
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
