require "dry-validation"
require_relative "types"

class DryValidataionMessage < Dry::Validation::Contract
  json do
    required(:error).value(:string)
    required(:message).value(:string)
    required(:details).hash do
      required(:messages).array(:string)
    end
  end
end
