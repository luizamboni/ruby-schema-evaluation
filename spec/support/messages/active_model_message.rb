require "active_model"

class RequiredStringType < ActiveModel::Type::Value
  def initialize(include_class: false)
    super()
    @include_class = include_class
  end

  def cast(value)
    value
  end

  def valid?(value)
    value.is_a?(String) && !value.empty?
  end

  def error_message(value)
    return "can't be blank" if value.nil? || value == ""
    return "must be a String" unless @include_class
    "must be a String, but got #{value.class}"
  end
end

class RequiredStringArrayType < ActiveModel::Type::Value
  def cast(value)
    value
  end

  def valid?(value)
    value.is_a?(Array) && !value.empty? && value.all? { |v| v.is_a?(String) }
  end

  def error_message(value)
    return "can't be blank" if value.nil? || value == []
    "must be an Array of String"
  end
end

class RequiredMessageDetailsType < ActiveModel::Type::Value
  def cast(value)
    return value if value.is_a?(ActiveModelMessageDetails)
    return ActiveModelMessageDetails.new(value) if value.is_a?(Hash)
    value
  end

  def valid?(value)
    value.is_a?(ActiveModelMessageDetails)
  end

  def error_message(value)
    return "can't be blank" if value.nil?
    "must be a ActiveModelMessageDetails"
  end
end

module ActiveModelSchemaEnforcer
  def self.included(base)
    base.prepend(InstanceMethods)
  end

  module InstanceMethods
    def initialize(args = nil)
      coerced = coerce_hash_attributes(args)
      super(coerced)
      validate!
    end

    private

    def coerce_hash_attributes(args)
      return args unless args.is_a?(Hash)

      coerced = args.dup
      self.class.attribute_types.each do |attr, type|
        value = coerced[attr]
        next unless value.is_a?(Hash)
        next unless type.respond_to?(:cast)

        coerced[attr] = type.cast(value)
      end
      coerced
    end
  end
end

module ActiveModelTypeEnforcer
  def self.included(base)
    base.validate :validate_attribute_types
  end

  private

  def validate_attribute_types
    self.class.attribute_types.each do |attr, type|
      next unless type.respond_to?(:valid?)

      value = public_send(attr)
      next if type.valid?(value)

      message = type.respond_to?(:error_message) ? type.error_message(value) : "is invalid"
      errors.add(attr, message)
    end
  end
end

module ActiveModelNestedErrorPropagator
  def self.included(base)
    base.validate :propagate_nested_errors
  end

  private

  def propagate_nested_errors
    self.class.attribute_types.each_key do |attr|
      value = public_send(attr)
      next unless value.respond_to?(:errors)

      value.valid?
      value.errors.each do |error|
        errors.add(:"#{attr}.#{error.attribute}", error.message)
      end
    end
  end
end

class ActiveModelMessageDetails
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  include ActiveModelTypeEnforcer

  attribute :messages, RequiredStringArrayType.new
end

class ActiveModelMessage
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  include ActiveModelSchemaEnforcer
  include ActiveModelTypeEnforcer
  include ActiveModelNestedErrorPropagator

  attribute :error, RequiredStringType.new
  attribute :message, RequiredStringType.new(include_class: true)
  attribute :details, RequiredMessageDetailsType.new
end
