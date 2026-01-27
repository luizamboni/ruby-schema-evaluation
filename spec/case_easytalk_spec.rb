require "spec_helper"

RSpec.describe "EasyTalk nested models" do
  it "builds a valid instance with nested hash" do
    message = EasyTalkMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    expect(message.error).to eq("NOT_FOUND")
    expect(message.message).to eq("missing")
    expect(message.details).to be_a(EasyTalkMessageDetails)
    expect(message.details.messages).to eq(["ok"])
  end

  it "raises UnknownAttributeError for unexpected top-level fields" do
    expect {
      EasyTalkMessage.new(error: "ok", message: "hi", details: { messages: ["ok"] }, extra: "nope")
    }.to raise_error(ActiveModel::UnknownAttributeError)
  end

  it "raises UnknownAttributeError for unexpected nested fields" do
    expect {
      EasyTalkMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: { messages: ["ok"], extra: "nope" }
      )
    }.to raise_error(ActiveModel::UnknownAttributeError)
  end

  it "accepts a nested EasyTalk model instance for object properties" do
    details = EasyTalkMessageDetails.new(messages: ["ok"])

    message = EasyTalkMessage.new(error: "NOT_FOUND", message: "missing", details: details)
  
    expect(message.details).to eq(details)
    expect(message.details.messages).to eq(["ok"])
  end

  it "accepts nested attributes via hash (case4 example shape)" do
    message = EasyTalkMessage.new(
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
      EasyTalkMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: 1
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details" => ["must be a object (got Integer)"] }) }
  end

  it "raises ValidationError when details.messages has wrong type" do
    expect {
      EasyTalkMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: { messages: "oops" }
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details.messages" => ["must be a array (got String)"] }) }
  end

  it "raises ValidationError when details.messages is missing" do
    expect {
      EasyTalkMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: {}
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details.messages" => ["is required"] }) }
  end

  it "raises ValidationError when top-level required fields are missing" do
    expect {
      EasyTalkMessage.new(details: { messages: ["ok"] })
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "error" => ["is required"], "message" => ["is required"] }) }
  end

  it "raises ValidationError when error has wrong type" do
    expect {
      EasyTalkMessage.new(
        error: 123,
        message: "missing",
        details: { messages: ["ok"] }
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "error" => ["must be a string (got Integer)"] }) }
  end

  it "raises ValidationError when details is nil" do
    expect {
      EasyTalkMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: nil
      )
    }.to raise_error(ValidationError) { |e| expect(e.errors).to eq({ "details" => ["is required"] }) }
  end
end
