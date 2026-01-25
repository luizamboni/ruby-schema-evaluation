require "spec_helper"

RSpec.describe "ActiveModel case" do
  it "raises for invalid types" do
    expect {
      ActiveModelMessage.new(error: 2, message: 1, details: { messages: [1] })
    }.to raise_error(ActiveModel::ValidationError) { |e|
      expect(e.model.errors.messages).to eq({
        error: ["must be a String"],
        message: ["must be a String, but got Integer"],
        :"details.messages" => ["must be an Array of String"]
      })
    }
  end

  it "accepts valid input" do
    message = ActiveModelMessage.new(error: "ok", message: "hi", details: { messages: ["ok"] })

    expect(message.error).to eq("ok")
    expect(message.message).to eq("hi")
    expect(message.valid?).to eq(true)
    expect(message.details).to be_a(ActiveModelMessageDetails)
    expect(message.details.messages).to eq(["ok"])
  end

  it "builds a valid instance with nested hash" do
    message = ActiveModelMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    expect(message.error).to eq("NOT_FOUND")
    expect(message.message).to eq("missing")
    expect(message.details).to be_a(ActiveModelMessageDetails)
    expect(message.details.messages).to eq(["ok"])
  end

  it "accepts a nested ActiveModelMessageDetails instance for object properties" do
    details = ActiveModelMessageDetails.new(messages: ["ok"])
    message = ActiveModelMessage.new(error: "NOT_FOUND", message: "missing", details: details)

    expect(message.details).to eq(details)
    expect(message.details.messages).to eq(["ok"])
  end

  it "accepts nested attributes via hash (case example shape)" do
    message = ActiveModelMessage.new(
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
      ActiveModelMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: 1
      )
    }.to raise_error(ActiveModel::ValidationError) { |e| expect(e.model.errors.messages).to eq({ details: ["must be a ActiveModelMessageDetails"] }) }
  end

  it "raises ValidationError when details.messages has wrong type" do
    expect {
      ActiveModelMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: { messages: "oops" }
      )
    }.to raise_error(ActiveModel::ValidationError) { |e| expect(e.model.errors.messages).to eq({ "details.messages": ["must be an Array of String"] }) }
  end

  it "raises ValidationError when details.messages is missing" do
    expect {
      ActiveModelMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: {}
      )
    }.to raise_error(ActiveModel::ValidationError) { |e| expect(e.model.errors.messages).to eq({ "details.messages": ["can't be blank"] }) }
  end

  it "raises ValidationError when top-level required fields are missing" do
    expect {
      ActiveModelMessage.new(details: { messages: ["ok"] })
    }.to raise_error(ActiveModel::ValidationError) { |e| expect(e.model.errors.messages).to eq({ error: ["can't be blank"], message: ["can't be blank"] }) }
  end

  it "raises ValidationError when error has wrong type" do
    expect {
      ActiveModelMessage.new(
        error: 123,
        message: "missing",
        details: { messages: ["ok"] }
      )
    }.to raise_error(ActiveModel::ValidationError) { |e| expect(e.model.errors.messages).to eq({ error: ["must be a String"] }) }
  end

  it "raises ValidationError when details is nil" do
    expect {
      ActiveModelMessage.new(
        error: "NOT_FOUND",
        message: "missing",
        details: nil
      )
    }.to raise_error(ActiveModel::ValidationError) { |e| expect(e.model.errors.messages).to eq({ details: ["can't be blank"] }) }
  end
end
