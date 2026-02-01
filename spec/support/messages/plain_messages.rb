require "dry-struct"
require "easy_talk"
require "sorbet-runtime"
require "active_model"
require_relative "types"

unless defined?(DryStructPlainMessageDetails)
  class DryStructPlainMessageDetails < Dry::Struct
    attribute :messages, Types::Strict::Array.of(Types::Strict::String)
  end
end

unless defined?(DryStructPlainMessage)
  class DryStructPlainMessage < Dry::Struct
    attribute :error, Types::Strict::String
    attribute :message, Types::Strict::String
    attribute :details, Types::Instance(DryStructPlainMessageDetails)
  end
end

unless defined?(SorbetPlainMessageDetails)
  class SorbetPlainMessageDetails < T::Struct
    const :messages, T::Array[String]
  end
end

unless defined?(SorbetPlainMessage)
  class SorbetPlainMessage < T::Struct
    const :error, String
    const :message, String
    const :details, SorbetPlainMessageDetails
  end
end

unless defined?(EasyTalkPlainMessageDetails)
  class EasyTalkPlainMessageDetails
    include EasyTalk::Model

    define_schema(validations: true) do
      property :messages, T::Array[String], { title: "Error Message", description: "A human-readable explanation of what is missing" }
    end
  end
end

unless defined?(EasyTalkPlainMessage)
  class EasyTalkPlainMessage
    include EasyTalk::Model

    define_schema(validations: true) do
      property :error, String, { title: "Error Type", description: "The error code (e.g., NOT_FOUND)" }
      property :message, T.must(String), { title: "Error Message", description: "A human-readable explanation of what is missing" }
      property :details, EasyTalkPlainMessageDetails
    end
  end
end

unless defined?(ActiveModelPlainMessageDetails)
  class ActiveModelPlainMessageDetails
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :messages, ActiveModel::Type::Value.new
  end
end

unless defined?(ActiveModelPlainMessage)
  class ActiveModelPlainMessage
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :error, ActiveModel::Type::Value.new
    attribute :message, ActiveModel::Type::Value.new
    attribute :details, ActiveModel::Type::Value.new
  end
end

unless defined?(ActiveModelNoEnforcementMessageDetails)
  ActiveModelNoEnforcementMessageDetails = ActiveModelPlainMessageDetails
end

unless defined?(ActiveModelNoEnforcementMessage)
  ActiveModelNoEnforcementMessage = ActiveModelPlainMessage
end
