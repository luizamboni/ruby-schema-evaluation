require "spec_helper"

RSpec.describe "Dry::Struct case" do
  it "raises for invalid type" do
    expect {
      DryStructMessage.new(error: "ok", message: 1, details: DryStructMessageDetails.new(messages: ["ok"]))
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "message" => ["is invalid"] }) }
  end

  it "accepts valid input" do
    details = DryStructMessageDetails.new(messages: ["ok"])
    message = DryStructMessage.new(error: "ok", message: "hi", details: details)

    expect(message.error).to eq("ok")
    expect(message.message).to eq("hi")
    expect(message.details).to eq(details)
    expect(message.details.messages).to eq(["ok"])
  end

  it "ignores unexpected top-level fields" do
    details = DryStructMessageDetails.new(messages: ["ok"])

    expect {
      DryStructMessage.new(error: "ok", message: "hi", details: details, extra: "nope")
    }.not_to raise_error
  end

  it "ignores unexpected nested fields" do
    expect {
      DryStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: { messages: ["ok"], extra: "nope" }
      )
    }.not_to raise_error
  end

  it "builds a valid instance with nested hash" do
    message = DryStructMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    expect(message.error).to eq("NOT_FOUND")
    expect(message.message).to eq("missing")
    expect(message.details).to be_a(DryStructMessageDetails)
    expect(message.details.messages).to eq(["ok"])
  end

  it "accepts a nested DryStructMessageDetails instance for object properties" do
    details = DryStructMessageDetails.new(messages: ["ok"])
    message = DryStructMessage.new(error: "NOT_FOUND", message: "missing", details: details)

    expect(message.details).to eq(details)
    expect(message.details.messages).to eq(["ok"])
  end

  it "accepts nested attributes via hash (case example shape)" do
    message = DryStructMessage.new(
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
      DryStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: 1
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details" => ["must be a DryStructMessageDetails (got Integer)"] }) }
  end

  it "raises ValidationError when details.messages has wrong type" do
    expect {
      DryStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: { messages: "oops" }
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details.messages" => ["must be an Array (got String)"] }) }
  end

  it "raises ValidationError when details.messages is missing" do
    expect {
      DryStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: {}
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details.messages" => ["is required"] }) }
  end

  it "raises ValidationError when top-level required fields are missing" do
    expect {
      DryStructMessage.new(details: { messages: ["ok"] })
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "error" => ["is required"], "message" => ["is required"] }) }
  end

  it "raises ValidationError when error has wrong type" do
    expect {
      DryStructMessage.new(
        error: 123,
        message: "missing",
        details: { messages: ["ok"] }
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "error" => ["is invalid"] }) }
  end

  it "raises ValidationError when details is nil" do
    expect {
      DryStructMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: nil
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details" => ["is required"] }) }
  end
end
