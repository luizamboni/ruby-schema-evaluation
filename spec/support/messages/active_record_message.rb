require "active_record"

module ActiveRecordSchemaEnforcer
  def self.included(base)
    base.prepend(InstanceMethods)
  end

  module InstanceMethods
    def initialize(attributes = nil)
      super(attributes)
      validate!
    end
  end
end

class ActiveRecordMessage < ActiveRecord::Base
  include ActiveRecordSchemaEnforcer

  attribute :error, ActiveRecord::Type::String.new
  attribute :message, ActiveRecord::Type::String.new
  attribute :details, ActiveRecord::Type::Value.new

  validate :validate_schema

  private

  def validate_schema
    unless error.is_a?(String) && !error.empty?
      errors.add(:error, "can't be blank")
    end

    unless message.is_a?(String) && !message.empty?
      errors.add(:message, "must be a String")
    end

    unless details.is_a?(Hash)
      errors.add(:details, "must be a Hash")
      return
    end

    messages = details[:messages] || details["messages"]
    unless messages.is_a?(Array) && !messages.empty? && messages.all? { |value| value.is_a?(String) }
      errors.add(:details, "messages must be an Array of String")
    end
  end
end
