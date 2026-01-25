require "spec_helper"

RSpec.describe "Dry::Validation case" do
  it "exposes error messages for invalid types" do
    result = DryValidataionMessage.new.(error: "ok", message: 1, details: { messages: ["ok"] })

    expect(result.errors.to_h).to eq({ message: ["must be a string"] })
  end

  it "accepts valid input" do
    result = DryValidataionMessage.new.(error: "ok", message: "hi", details: { messages: ["ok"] })

    expect(result.errors.to_h).to eq({})
    expect(result.to_h).to eq({ error: "ok", message: "hi", details: { messages: ["ok"] } })
  end
end
