require "spec_helper"

RSpec.describe "Dry::Validation case" do
  let(:valid_hash) do
    { error: "ok", message: "hi", details: { messages: ["ok"] } }
  end

  it "exposes error messages for invalid types" do
    result = DryValidataionMessage.new.(error: "ok", message: 1, details: { messages: ["ok"] })

    expect(result.errors.to_h).to eq({ message: ["must be a string"] })
  end

  it "accepts valid input" do
    result = DryValidataionMessage.new.(valid_hash)

    expect(result.errors.to_h).to eq({})
    expect(result.to_h).to eq(valid_hash)
  end

  it "ignores unexpected top-level fields" do
    result = DryValidataionMessage.new.(valid_hash.merge(extra: "nope"))

    expect(result.errors.to_h).to eq({})
    expect(result.to_h).to eq(valid_hash)
  end

  it "ignores unexpected nested fields" do
    result = DryValidataionMessage.new.(valid_hash.merge(details: { messages: ["ok"], extra: "nope" }))

    expect(result.errors.to_h).to eq({})
    expect(result.to_h).to eq(valid_hash)
  end
end
