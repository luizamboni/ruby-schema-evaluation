require "spec_helper"
require "benchmark"
require "action_controller"

RSpec.describe "Attribute access benchmark" do
  ITERATIONS = 1_000_000

  it "compares DTO attribute access vs hash access" do
    dry_struct = DryStructMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    dry_struct_plain = DryStructPlainMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: DryStructPlainMessageDetails.new(messages: ["ok"])
    )

    sorbet_struct = SorbetStructMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    sorbet_struct_plain = SorbetPlainMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: SorbetPlainMessageDetails.new(messages: ["ok"])
    )

    easytalk = EasyTalkMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    easytalk_plain = EasyTalkPlainMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: EasyTalkPlainMessageDetails.new(messages: ["ok"])
    )

    activemodel = ActiveModelMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    activemodel_plain = ActiveModelPlainMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: ActiveModelPlainMessageDetails.new(messages: ["ok"])
    )

    activemodel_no_enforcement = ActiveModelNoEnforcementMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: ActiveModelNoEnforcementMessageDetails.new(messages: ["ok"])
    )

    active_record = ActiveRecordMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    symbol_hash = {
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    }

    string_hash = {
      "error" => "NOT_FOUND",
      "message" => "missing",
      "details" => { "messages" => ["ok"] }
    }

    params = ActionController::Parameters.new(
      "error" => "NOT_FOUND",
      "message" => "missing",
      "details" => { "messages" => ["ok"] }
    )

    results = {}

    results[:dry_struct_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += dry_struct.error.length
        sum += dry_struct.message.length
        sum += dry_struct.details.messages.length
      end
      sum
    end

    results[:dry_struct_plain_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += dry_struct_plain.error.length
        sum += dry_struct_plain.message.length
        sum += dry_struct_plain.details.messages.length
      end
      sum
    end

    results[:sorbet_struct_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += sorbet_struct.error.length
        sum += sorbet_struct.message.length
        sum += sorbet_struct.details.messages.length
      end
      sum
    end

    results[:sorbet_struct_plain_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += sorbet_struct_plain.error.length
        sum += sorbet_struct_plain.message.length
        sum += sorbet_struct_plain.details.messages.length
      end
      sum
    end

    results[:easytalk_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += easytalk.error.length
        sum += easytalk.message.length
        sum += easytalk.details.messages.length
      end
      sum
    end

    results[:easytalk_plain_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += easytalk_plain.error.length
        sum += easytalk_plain.message.length
        sum += easytalk_plain.details.messages.length
      end
      sum
    end

    results[:activemodel_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += activemodel.error.length
        sum += activemodel.message.length
        sum += activemodel.details.messages.length
      end
      sum
    end

    results[:activemodel_plain_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += activemodel_plain.error.length
        sum += activemodel_plain.message.length
        sum += activemodel_plain.details.messages.length
      end
      sum
    end

    results[:activemodel_no_enforcement_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += activemodel_no_enforcement.error.length
        sum += activemodel_no_enforcement.message.length
        sum += activemodel_no_enforcement.details.messages.length
      end
      sum
    end

    results[:active_record_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += active_record.error.length
        sum += active_record.message.length
        sum += active_record.details[:messages].length
      end
      sum
    end

    results[:hash_symbol_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += symbol_hash[:error].length
        sum += symbol_hash[:message].length
        sum += symbol_hash[:details][:messages].length
      end
      sum
    end

    results[:hash_string_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += string_hash["error"].length
        sum += string_hash["message"].length
        sum += string_hash["details"]["messages"].length
      end
      sum
    end

    results[:params_symbol_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += params[:error].length
        sum += params[:message].length
        sum += params[:details][:messages].length
      end
      sum
    end

    results[:params_string_access] = Benchmark.realtime do
      sum = 0
      ITERATIONS.times do
        sum += params["error"].length
        sum += params["message"].length
        sum += params["details"]["messages"].length
      end
      sum
    end

    puts "\n== attribute access (#{ITERATIONS} iterations) =="
    puts format("%-25s %10s %12s", "name", "time(s)", "us/op")

    sorted = results
      .sort_by { |_, time| time }
    sorted.each do |name, time|
        us_per_op = (time * 1_000_000.0 / ITERATIONS)
        puts format("%-25s %10.4f %12.2f", name, time, us_per_op)
    end

    report_date = Time.now.strftime("%Y-%m-%d")
    report_path = "BENCHMARK_ATTRIBUTE_ACCESS_#{report_date}.md"
    report_lines = []
    report_lines << "# Attribute Access Benchmark"
    report_lines << ""
    report_lines << "Run: `bundle exec rspec spec/benchmark_attribute_access_spec.rb`"
    report_lines << "Date: #{report_date}"
    report_lines << "Ruby: #{RUBY_VERSION}"
    report_lines << "Rails: #{ActionPack::VERSION::STRING}"
    report_lines << "Iterations: #{ITERATIONS}"
    report_lines << ""
    report_lines << "## Attribute Access"
    report_lines << "| name | time(s) | us/op |"
    report_lines << "| --- | --- | --- |"
    sorted.each do |name, time|
      us_per_op = (time * 1_000_000.0 / ITERATIONS)
      report_lines << format("| %s | %.4f | %.2f |", name, time, us_per_op)
    end
    File.write(report_path, report_lines.join("\n") + "\n")

    expect(results.keys).to match_array([
      :dry_struct_access,
      :dry_struct_plain_access,
      :sorbet_struct_access,
      :sorbet_struct_plain_access,
      :easytalk_access,
      :easytalk_plain_access,
      :activemodel_access,
      :activemodel_plain_access,
      :activemodel_no_enforcement_access,
      :active_record_access,
      :hash_symbol_access,
      :hash_string_access,
      :params_symbol_access,
      :params_string_access
    ])
  end
end
