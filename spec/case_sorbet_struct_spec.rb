require "spec_helper"

RSpec.describe "Sorbet T::Struct case" do
  it "raises for invalid type" do
    expect {
      SorbetStructMessage.new(error: "ok", message: 1, details: SorbetStructMessageDetails.new(messages: ["ok"]))
    }.to raise_error(ValidationError) { |e|
      expect(e.errors).to have_key("message")
    }
  end

  it "accepts valid input" do
    details = SorbetStructMessageDetails.new(messages: ["ok"])
    message = SorbetStructMessage.new(error: "ok", message: "hi", details: details)

    expect(message.error).to eq("ok")
    expect(message.message).to eq("hi")
    expect(message.details).to eq(details)
    expect(message.details.messages).to eq(["ok"])
  end

  it "raises ValidationError for unexpected top-level fields" do
    details = SorbetStructMessageDetails.new(messages: ["ok"])

    expect {
      SorbetStructMessage.new(error: "ok", message: "hi", details: details, extra: "nope")
    }.to raise_error(ValidationError) { |e|
      expect(e.errors).to eq({ "extra" => ["is not permitted"] })
    }
  end

  it "raises ValidationError for unexpected nested fields" do
    expect {
      SorbetStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: { messages: ["ok"], extra: "nope" }
      )
    }.to raise_error(ValidationError) { |e|
      expect(e.errors).to eq({ "details.extra" => ["is not permitted"] })
    }
  end

  it "builds a valid instance with nested hash" do
    message = SorbetStructMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    expect(message.error).to eq("NOT_FOUND")
    expect(message.message).to eq("missing")
    expect(message.details).to be_a(SorbetStructMessageDetails)
    expect(message.details.messages).to eq(["ok"])
  end

  it "accepts a nested SorbetStructMessageDetails instance for object properties" do
    details = SorbetStructMessageDetails.new(messages: ["ok"])
    message = SorbetStructMessage.new(error: "NOT_FOUND", message: "missing", details: details)

    expect(message.details).to eq(details)
    expect(message.details.messages).to eq(["ok"])
  end

  it "accepts nested attributes via hash (case example shape)" do
    message = SorbetStructMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["teste de tetalhe"] }
    )

    expect(message.error).to eq("NOT_FOUND")
    expect(message.message).to eq("missing")
    expect(message.details.messages).to eq(["teste de tetalhe"])
  end

  it "raises ValidationError when details is not an object" do
    expect {
      SorbetStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: 1
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details" => ["must be a SorbetStructMessageDetails (got Integer)"] }) }
  end

  it "raises ValidationError when details.messages has wrong type" do
    expect {
      SorbetStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: { messages: "oops" }
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details.messages" => ["must be an Array (got String)"] }) }
  end

  it "raises ValidationError when details.messages is missing" do
    expect {
      SorbetStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: {}
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details.messages" => ["is required"] }) }
  end

  it "raises ValidationError when top-level required fields are missing" do
    expect {
      SorbetStructMessage.new(details: { messages: ["ok"] })
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "error" => ["is required"], "message" => ["is required"] }) }
  end

  it "raises ValidationError when error has wrong type" do
    expect {
      SorbetStructMessage.new(
        error: 123,
        message: "missing",
        details: { messages: ["ok"] }
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "error" => ["is invalid"] }) }
  end

  it "raises ValidationError when details is nil" do
    expect {
      SorbetStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: nil
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details" => ["is required"] }) }
  end
end
