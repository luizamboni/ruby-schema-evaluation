require "spec_helper"

RSpec.describe "Validation comparison matrix" do
  let(:valid_hash) do
    { error: "NOT_FOUND", message: "missing", details: { messages: ["ok"] } }
  end

  context "Dry::Validation::Contract" do
    it "1) type enforcement (message integer)" do
      result = DryValidataionMessage.new.(valid_hash.merge(message: 1))
      expect(result.errors.to_h).to eq({ message: ["must be a string"] })
    end

    it "2) nested object validation (details missing messages)" do
      result = DryValidataionMessage.new.(valid_hash.merge(details: {}))
      expect(result.errors.to_h).to eq({ details: { messages: ["is missing"] } })
    end

    it "3) array item type validation (details.messages has integer)" do
      result = DryValidataionMessage.new.(valid_hash.merge(details: { messages: [1] }))
      expect(result.errors.to_h).to eq({ details: { messages: { 0 => ["must be a string"] } } })
    end

    it "4) required fields (missing error)" do
      result = DryValidataionMessage.new.(valid_hash.reject { |k, _| k == :error })
      expect(result.errors.to_h).to eq({ error: ["is missing"] })
    end

    it "5) error shape (no exception, errors hash)" do
      result = DryValidataionMessage.new.(valid_hash.merge(message: 1))
      expect(result).to respond_to(:errors)
      expect(result.errors.to_h).to eq({ message: ["must be a string"] })
    end

    it "6) coercion attempt (error integer)" do
      result = DryValidataionMessage.new.(valid_hash.merge(error: 123))
      expect(result.errors.to_h).to eq({ error: ["must be a string"] })
    end

    it "7) unknown properties (ignored by schema)" do
      result = DryValidataionMessage.new.(valid_hash.merge(foo: "bar"))
      expect(result.errors.to_h).to eq({})
    end

    it "8) exception vs errors API" do
      expect { DryValidataionMessage.new.(valid_hash.merge(message: 1)) }.not_to raise_error
    end
  end

  context "Dry::Struct" do
    let(:details) { DryStructMessageDetails.new(messages: ["ok"]) }

    it "1) type enforcement (message integer)" do
      expect { DryStructMessage.new(valid_hash.merge(details: details, message: 1)) }
        .to raise_error(ValidationError)
    end

    it "2) nested object validation (details missing messages)" do
      expect { DryStructMessage.new(valid_hash.merge(details: {})) }
        .to raise_error(ValidationError)
    end

    it "3) array item type validation (details.messages has integer)" do
      expect { DryStructMessage.new(valid_hash.merge(details: { messages: [1] })) }
        .to raise_error(ValidationError)
    end

    it "4) required fields (missing error)" do
      expect { DryStructMessage.new(message: "ok", details: details) }
        .to raise_error(ValidationError)
    end

    it "5) error shape (exception only)" do
      expect { DryStructMessage.new(valid_hash.merge(details: details, message: 1)) }
        .to raise_error(ValidationError)
    end

    it "6) coercion attempt (error integer)" do
      expect { DryStructMessage.new(valid_hash.merge(details: details, error: 123)) }
        .to raise_error(ValidationError)
    end

    it "7) unknown properties (top-level)" do
      expect { DryStructMessage.new(valid_hash.merge(details: details, foo: "bar")) }
        .not_to raise_error
    end

    it "8) exception vs errors API" do
      expect { DryStructMessage.new(valid_hash.merge(details: details, message: 1)) }
        .to raise_error(ValidationError)
    end
  end

  context "Sorbet T::Struct" do
    let(:details) { SorbetStructMessageDetails.new(messages: ["ok"]) }

    it "1) type enforcement (message integer)" do
      expect { SorbetStructMessage.new(valid_hash.merge(details: details, message: 1)) }
        .to raise_error(ValidationError)
    end

    it "2) nested object validation (details missing messages)" do
      expect { SorbetStructMessage.new(valid_hash.merge(details: {})) }
        .to raise_error(ValidationError)
    end

    it "3) array item type validation (details.messages has integer)" do
      expect { SorbetStructMessage.new(valid_hash.merge(details: { messages: [1] })) }
        .to raise_error(ValidationError)
    end

    it "4) required fields (missing error)" do
      expect { SorbetStructMessage.new(message: "ok", details: details) }
        .to raise_error(ValidationError)
    end

    it "5) error shape (exception only)" do
      expect { SorbetStructMessage.new(valid_hash.merge(details: details, message: 1)) }
        .to raise_error(ValidationError)
    end

    it "6) coercion attempt (error integer)" do
      expect { SorbetStructMessage.new(valid_hash.merge(details: details, error: 123)) }
        .to raise_error(ValidationError)
    end

    it "7) unknown properties (top-level)" do
      expect { SorbetStructMessage.new(valid_hash.merge(details: details, foo: "bar")) }
        .to raise_error(ValidationError)
    end

    it "8) exception vs errors API" do
      expect { SorbetStructMessage.new(valid_hash.merge(details: details, message: 1)) }
        .to raise_error(ValidationError)
    end
  end

  context "EasyTalk (custom SchemaEnforcer)" do
    it "1) type enforcement (message integer)" do
      expect { EasyTalkMessage.new(valid_hash.merge(message: 1)) }
        .to raise_error(ValidationError) { |e|
          expect(e.errors).to eq({ "message" => ["must be a string (got Integer)"] })
        }
    end

    it "2) nested object validation (details missing messages)" do
      expect { EasyTalkMessage.new(valid_hash.merge(details: {})) }
        .to raise_error(ValidationError) { |e|
          expect(e.errors).to eq({ "details.messages" => ["is required"] })
        }
    end

    it "3) array item type validation (details.messages has integer)" do
      expect { EasyTalkMessage.new(valid_hash.merge(details: { messages: [1] })) }
        .not_to raise_error
    end

    it "4) required fields (missing error)" do
      expect { EasyTalkMessage.new(valid_hash.reject { |k, _| k == :error }) }
        .to raise_error(ValidationError) { |e|
          expect(e.errors).to eq({ "error" => ["is required"] })
        }
    end

    it "5) error shape (exception with custom errors hash)" do
      expect { EasyTalkMessage.new(valid_hash.merge(message: 1)) }
        .to raise_error(ValidationError) { |e|
          expect(e.errors).to be_a(Hash)
        }
    end

    it "6) coercion attempt (error integer)" do
      expect { EasyTalkMessage.new(valid_hash.merge(error: 123)) }
        .to raise_error(ValidationError) { |e|
          expect(e.errors).to eq({ "error" => ["must be a string (got Integer)"] })
        }
    end

    it "7) unknown properties (top-level ignored, nested raises from EasyTalk)" do
      expect { EasyTalkMessage.new(valid_hash.merge(foo: "bar")) }
        .to raise_error(ActiveModel::UnknownAttributeError)

      expect { EasyTalkMessage.new(valid_hash.merge(details: { messages: ["ok"], foo: "bar" })) }
        .to raise_error(ActiveModel::UnknownAttributeError)
    end

    it "8) exception vs errors API" do
      expect { EasyTalkMessage.new(valid_hash.merge(message: 1)) }
        .to raise_error(ValidationError)
    end
  end

  context "ActiveModel" do
    it "1) type enforcement (message integer)" do
      expect { ActiveModelMessage.new(valid_hash.merge(message: 1)) }
        .to raise_error(ActiveModel::ValidationError) { |e|
          expect(e.model.errors.messages).to include(message: ["must be a String, but got Integer"])
        }
    end

    it "2) nested object validation (details missing messages)" do
      expect { ActiveModelMessage.new(valid_hash.merge(details: {})) }
        .to raise_error(ActiveModel::ValidationError) { |e|
          expect(e.model.errors.messages).to eq({ "details.messages": ["can't be blank"] })
        }
    end

    it "3) array item type validation (details.messages has integer)" do
      expect { ActiveModelMessage.new(valid_hash.merge(details: { messages: [1] })) }
        .to raise_error(ActiveModel::ValidationError) { |e|
          expect(e.model.errors.messages).to eq({ "details.messages": ["must be an Array of String"] })
        }
    end

    it "4) required fields (missing error)" do
      expect { ActiveModelMessage.new(valid_hash.reject { |k, _| k == :error }) }
        .to raise_error(ActiveModel::ValidationError) { |e|
          expect(e.model.errors.messages).to include(error: ["can't be blank"])
        }
    end

    it "5) error shape (exception with ActiveModel::Errors)" do
      expect { ActiveModelMessage.new(valid_hash.merge(message: 1)) }
        .to raise_error(ActiveModel::ValidationError) { |e|
          expect(e.model.errors).to be_a(ActiveModel::Errors)
        }
    end

    it "6) coercion attempt (error integer)" do
      expect { ActiveModelMessage.new(valid_hash.merge(error: 123)) }
        .to raise_error(ActiveModel::ValidationError) { |e|
          expect(e.model.errors.messages).to include(error: ["must be a String"])
        }
    end

    it "7) unknown properties (top-level, nested)" do
      expect { ActiveModelMessage.new(valid_hash.merge(foo: "bar")) }
        .to raise_error(ActiveModel::UnknownAttributeError)

      expect { ActiveModelMessage.new(valid_hash.merge(details: { messages: ["ok"], foo: "bar" })) }
        .to raise_error(ActiveModel::UnknownAttributeError)
    end

    it "8) exception vs errors API" do
      expect { ActiveModelMessage.new(valid_hash.merge(message: 1)) }
        .to raise_error(ActiveModel::ValidationError)
    end
  end
end
