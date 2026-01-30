require "spec_helper"
require "benchmark"
require "json"
require "objspace"
require "memory_profiler"
require "action_controller"

RSpec.describe "Validation benchmark" do
  ITERATIONS = 10_000

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

  def measure_memory
    GC.start
    before = ObjectSpace.memsize_of_all
    yield
    GC.start
    after = ObjectSpace.memsize_of_all
    after - before
  end

  def run_validations(iterations)
    iterations.times do
      yield
    end
  end

  def serialize_value(obj)
    return obj.to_h if obj.respond_to?(:to_h)
    return obj.as_json if obj.respond_to?(:as_json)
    return obj.attributes if obj.respond_to?(:attributes)
    return obj.to_hash if obj.respond_to?(:to_hash)
    obj
  end

  def strong_parameters_expect_hash(params)
    error, message, details = params.expect(:error, :message, details: { messages: [] })
    {
      error: error,
      message: message,
      details: serialize_value(details)
    }
  end

  it "runs #{ITERATIONS} validations for each approach" do
    results = {}

    results[:dry_validation] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          DryValidataionMessage.new.(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          DryValidataionMessage.new.(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end
    }

    results[:dry_struct] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          DryStructMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          DryStructMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end
    }

    results[:dry_struct_plain] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          DryStructPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: DryStructPlainMessageDetails.new(messages: ["ok"])
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          DryStructPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: DryStructPlainMessageDetails.new(messages: ["ok"])
          )
        end
      end
    }

    results[:sorbet_struct] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          SorbetStructMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          SorbetStructMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end
    }

    results[:sorbet_struct_plain] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          SorbetPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: SorbetPlainMessageDetails.new(messages: ["ok"])
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          SorbetPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: SorbetPlainMessageDetails.new(messages: ["ok"])
          )
        end
      end
    }

    results[:easytalk] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          EasyTalkMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          EasyTalkMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end
    }

    results[:easytalk_plain] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          EasyTalkPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: EasyTalkPlainMessageDetails.new(messages: ["ok"])
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          EasyTalkPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: EasyTalkPlainMessageDetails.new(messages: ["ok"])
          )
        end
      end
    }

    results[:activemodel] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          ActiveModelMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          ActiveModelMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end
    }

    results[:activemodel_plain] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          ActiveModelPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: ActiveModelPlainMessageDetails.new(messages: ["ok"])
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          ActiveModelPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: ActiveModelPlainMessageDetails.new(messages: ["ok"])
          )
        end
      end
    }

    results[:active_record] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          ActiveRecordMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          ActiveRecordMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      end
    }

    results[:strong_parameters] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).permit(:error, :message, details: { messages: [] })
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).permit(:error, :message, details: { messages: [] })
        end
      end
    }

    results[:strong_parameters_expect] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).expect(:error, :message, details: { messages: [] })
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).expect(:error, :message, details: { messages: [] })
        end
      end
    }

    results[:strong_parameters_permit_all] = {
      time: Benchmark.realtime do
        run_validations(ITERATIONS) do
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).permit!
        end
      end,
      mem: measure_memory do
        run_validations(ITERATIONS) do
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).permit!
        end
      end
    }

    puts "\n== validation (#{ITERATIONS} iterations) =="
    puts format("%-30s %10s %12s %12s", "name", "time(s)", "us/op", "bytes")
    results
      .sort_by { |_, data| data[:time] }
      .each do |name, data|
        us_per_op = (data[:time] * 1_000_000.0 / ITERATIONS)
        puts format("%-30s %10.4f %12.2f %12d", name, data[:time], us_per_op, data[:mem])
      end

    expect(results.keys).to match_array([
      :dry_validation,
      :dry_struct,
      :dry_struct_plain,
      :sorbet_struct,
      :sorbet_struct_plain,
      :easytalk,
      :easytalk_plain,
      :activemodel,
      :activemodel_plain,
      :active_record,
      :strong_parameters,
      :strong_parameters_expect,
      :strong_parameters_permit_all
    ])
  end

  it "serializes #{ITERATIONS} instances for each approach (JSON)" do
    dry_validation_result = DryValidataionMessage.new.(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    dry_struct_instance = DryStructMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    dry_struct_plain_instance = DryStructPlainMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: DryStructPlainMessageDetails.new(messages: ["ok"])
    )

    sorbet_struct_instance = SorbetStructMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    sorbet_struct_plain_instance = SorbetPlainMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: SorbetPlainMessageDetails.new(messages: ["ok"])
    )

    easytalk_instance = EasyTalkMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    easytalk_plain_instance = EasyTalkPlainMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: EasyTalkPlainMessageDetails.new(messages: ["ok"])
    )

    activemodel_instance = ActiveModelMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    activemodel_plain_instance = ActiveModelPlainMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: ActiveModelPlainMessageDetails.new(messages: ["ok"])
    )

    active_record_instance = ActiveRecordMessage.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    )

    strong_parameters_instance = ActionController::Parameters.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    ).permit(:error, :message, details: { messages: [] })

    strong_parameters_expect_instance = strong_parameters_expect_hash(
      ActionController::Parameters.new(
        error: "NOT_FOUND",
        message: "missing",
        details: { messages: ["ok"] }
      )
    )

    strong_parameters_permit_all_instance = ActionController::Parameters.new(
      error: "NOT_FOUND",
      message: "missing",
      details: { messages: ["ok"] }
    ).permit!

    targets = {
      dry_validation: -> { serialize_value(dry_validation_result.to_h) },
      dry_struct: -> { serialize_value(dry_struct_instance) },
      dry_struct_plain: -> { serialize_value(dry_struct_plain_instance) },
      sorbet_struct: -> { serialize_value(sorbet_struct_instance) },
      sorbet_struct_plain: -> { serialize_value(sorbet_struct_plain_instance) },
      easytalk: -> { serialize_value(easytalk_instance) },
      easytalk_plain: -> { serialize_value(easytalk_plain_instance) },
      activemodel: -> { serialize_value(activemodel_instance) },
      activemodel_plain: -> { serialize_value(activemodel_plain_instance) },
      active_record: -> { serialize_value(active_record_instance) },
      strong_parameters: -> { serialize_value(strong_parameters_instance) },
      strong_parameters_expect: -> { serialize_value(strong_parameters_expect_instance) },
      strong_parameters_permit_all: -> { serialize_value(strong_parameters_permit_all_instance) }
    }

    results = {}
    targets.each do |name, fn|
      results[name] = {
        time: Benchmark.realtime do
          run_validations(ITERATIONS) do
            JSON.generate(fn.call)
          end
        end,
        mem: measure_memory do
          run_validations(ITERATIONS) do
            JSON.generate(fn.call)
          end
        end
      }
    end

    puts "\n== serialization json (#{ITERATIONS} iterations) =="
    puts format("%-30s %10s %12s %12s", "name", "time(s)", "us/op", "bytes")
    results
      .sort_by { |_, data| data[:time] }
      .each do |name, data|
        us_per_op = (data[:time] * 1_000_000.0 / ITERATIONS)
        puts format("%-30s %10.4f %12.2f %12d", name, data[:time], us_per_op, data[:mem])
      end

    expect(results.keys).to match_array(targets.keys)
  end

  it "creates and serializes #{ITERATIONS} instances for each approach (JSON)" do
    targets = {
      dry_validation: -> {
        DryValidataionMessage.new.(
          error: "NOT_FOUND",
          message: "missing",
          details: { messages: ["ok"] }
        ).to_h
      },
      dry_struct: -> {
        serialize_value(
          DryStructMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        )
      },
      dry_struct_plain: -> {
        serialize_value(
          DryStructPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: DryStructPlainMessageDetails.new(messages: ["ok"])
          )
        )
      },
      sorbet_struct: -> {
        serialize_value(
          SorbetStructMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        )
      },
      sorbet_struct_plain: -> {
        serialize_value(
          SorbetPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: SorbetPlainMessageDetails.new(messages: ["ok"])
          )
        )
      },
      easytalk: -> {
        serialize_value(
          EasyTalkMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        )
      },
      easytalk_plain: -> {
        serialize_value(
          EasyTalkPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: EasyTalkPlainMessageDetails.new(messages: ["ok"])
          )
        )
      },
      activemodel: -> {
        serialize_value(
          ActiveModelMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        )
      },
      activemodel_plain: -> {
        serialize_value(
          ActiveModelPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: ActiveModelPlainMessageDetails.new(messages: ["ok"])
          )
        )
      },
      active_record: -> {
        serialize_value(
          ActiveRecordMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        )
      },
      strong_parameters: -> {
        serialize_value(
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).permit(:error, :message, details: { messages: [] })
        )
      },
      strong_parameters_expect: -> {
        serialize_value(
          strong_parameters_expect_hash(
            ActionController::Parameters.new(
              error: "NOT_FOUND",
              message: "missing",
              details: { messages: ["ok"] }
            )
          )
        )
      },
      strong_parameters_permit_all: -> {
        serialize_value(
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).permit!
        )
      }
    }

    results = {}
    targets.each do |name, fn|
      results[name] = {
        time: Benchmark.realtime do
          run_validations(ITERATIONS) do
            JSON.generate(fn.call)
          end
        end,
        mem: measure_memory do
          run_validations(ITERATIONS) do
            JSON.generate(fn.call)
          end
        end
      }
    end

    puts "\n== create + serialize json (#{ITERATIONS} iterations) =="
    puts format("%-30s %10s %12s %12s", "name", "time(s)", "us/op", "bytes")
    results
      .sort_by { |_, data| data[:time] }
      .each do |name, data|
        us_per_op = (data[:time] * 1_000_000.0 / ITERATIONS)
        puts format("%-30s %10.4f %12.2f %12d", name, data[:time], us_per_op, data[:mem])
      end

    expect(results.keys).to match_array(targets.keys)
  end

  it "profiles allocations for each approach (MemoryProfiler, #{ITERATIONS} iterations)" do
    profiles = {
      dry_validation: -> {
        run_validations(ITERATIONS) do
          DryValidataionMessage.new.(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      },
      dry_struct: -> {
        run_validations(ITERATIONS) do
          DryStructMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      },
      dry_struct_plain: -> {
        run_validations(ITERATIONS) do
          DryStructPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: DryStructPlainMessageDetails.new(messages: ["ok"])
          )
        end
      },
      sorbet_struct: -> {
        run_validations(ITERATIONS) do
          SorbetStructMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      },
      sorbet_struct_plain: -> {
        run_validations(ITERATIONS) do
          SorbetPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: SorbetPlainMessageDetails.new(messages: ["ok"])
          )
        end
      },
      easytalk: -> {
        run_validations(ITERATIONS) do
          EasyTalkMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      },
      easytalk_plain: -> {
        run_validations(ITERATIONS) do
          EasyTalkPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: EasyTalkPlainMessageDetails.new(messages: ["ok"])
          )
        end
      },
      activemodel: -> {
        run_validations(ITERATIONS) do
          ActiveModelMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      },
      activemodel_plain: -> {
        run_validations(ITERATIONS) do
          ActiveModelPlainMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: ActiveModelPlainMessageDetails.new(messages: ["ok"])
          )
        end
      },
      active_record: -> {
        run_validations(ITERATIONS) do
          ActiveRecordMessage.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          )
        end
      },
      strong_parameters: -> {
        run_validations(ITERATIONS) do
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).permit(:error, :message, details: { messages: [] })
        end
      },
      strong_parameters_expect: -> {
        run_validations(ITERATIONS) do
          strong_parameters_expect_hash(
            ActionController::Parameters.new(
              error: "NOT_FOUND",
              message: "missing",
              details: { messages: ["ok"] }
            )
          )
        end
      },
      strong_parameters_permit_all: -> {
        run_validations(ITERATIONS) do
          ActionController::Parameters.new(
            error: "NOT_FOUND",
            message: "missing",
            details: { messages: ["ok"] }
          ).permit!
        end
      }
    }

    profile_reports = profiles.transform_values do |fn|
      MemoryProfiler.report { fn.call }
    end

    profile_reports
      .sort_by do |_, report|
        if report.respond_to?(:total_allocated_memsize)
          report.total_allocated_memsize
        elsif report.respond_to?(:total_allocated)
          report.total_allocated
        else
          Float::INFINITY
        end
      end
      .each do |name, report|
        puts "\n== #{name} (#{ITERATIONS} iterations) =="
        report.pretty_print(
          to_file: nil,
          scale_bytes: true,
          normalize_paths: true,
          detailed_report: false
        )
      end

    expect(profiles.keys).to match_array([
      :dry_validation,
      :dry_struct,
      :dry_struct_plain,
      :sorbet_struct,
      :sorbet_struct_plain,
      :easytalk,
      :easytalk_plain,
      :activemodel,
      :activemodel_plain,
      :active_record,
      :strong_parameters,
      :strong_parameters_expect,
      :strong_parameters_permit_all
    ])
  end
end
