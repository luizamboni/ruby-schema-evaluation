require "easy_talk"
require "sorbet-runtime"
require_relative "validation_error"

module SchemaEnforcer # to be used with EasyTalk
  TYPE_MAPPING = {
    "string"  => String,
    "integer" => Integer,
    "number"  => [ Integer, Float ],
    "boolean" => [ TrueClass, FalseClass ],
    "array"   => Array,
    "object"  => Hash
  }.freeze

  def initialize(attributes = {})
    @errors = ValidationError.new
    if attributes.is_a?(Hash)
      validate_against_schema_for(attributes, self.class.json_schema, nil)
      raise @errors unless @errors.errors.empty?
    end

    super(attributes)

    validate_against_schema
    raise @errors unless @errors.errors.empty?
  end

  private

  def validate_against_schema
    validate_against_schema_for(self, self.class.json_schema, nil)
    nil
  end

  def validate_against_schema_for(instance, schema, prefix)
    properties = schema["properties"] || {}
    required_fields = schema["required"] || []

    properties.each do |prop_name, rules|
      value = if instance.is_a?(Hash)
        instance.key?(prop_name.to_s) ? instance[prop_name.to_s] : instance[prop_name.to_sym]
      else
        instance.public_send(prop_name)
      end
      full_key = prefix ? "#{prefix}.#{prop_name}" : prop_name

      if required_fields.include?(prop_name.to_s) && value.nil?
        @errors.add(key: full_key, value: "is required")
        next
      end

      next if value.nil?

      expected_json_type = rules["type"]
      ruby_class = TYPE_MAPPING[expected_json_type]

      if ruby_class
        is_valid_type = ruby_class.is_a?(Array) ? ruby_class.any? { |c| value.is_a?(c) } : value.is_a?(ruby_class)
        if expected_json_type == "object"
          is_valid_type ||= value.is_a?(Hash) || value.class.respond_to?(:json_schema)
        end

        unless is_valid_type
          @errors.add(key: full_key, value: "must be a #{expected_json_type} (got #{value.class})")
          next
        end
      end

      if expected_json_type == "object"
        nested_schema = if value.class.respond_to?(:json_schema)
          value.class.json_schema
        else
          rules
        end

        validate_against_schema_for(value, nested_schema, full_key)
      end
    end
  end
end

class EasyTalkMessageDetails
  include EasyTalk::Model
  include SchemaEnforcer

  define_schema(validations: true) do
    property :messages, T::Array[String], { title: "Error Message", description: "A human-readable explanation of what is missing" }
  end
end

class EasyTalkMessage
  include EasyTalk::Model
  include SchemaEnforcer

  define_schema(validations: true) do
    property :error, String, { title: "Error Type", description: "The error code (e.g., NOT_FOUND)" }
    property :message, T.must(String), { title: "Error Message", description: "A human-readable explanation of what is missing" }
    property :details, EasyTalkMessageDetails
  end
end
