require "spec_helper"
require "benchmark"
require "objspace"
require "memory_profiler"
require "action_controller"

RSpec.describe "Validation benchmark (failed cases)" do
  FAILED_ITERATIONS = 10_000

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

  def capture_validation_errors
    yield
  rescue ValidationError
    nil
  end

  def validation_triggered?(name, invalid_payload)
    case name
    when :dry_validation
      DryValidataionMessage.new.(invalid_payload).failure?
    when :dry_struct
      begin
        DryStructMessage.new(invalid_payload)
        false
      rescue ValidationError
        true
      end
    when :sorbet_struct
      begin
        SorbetStructMessage.new(invalid_payload)
        false
      rescue ValidationError
        true
      end
    when :easytalk
      begin
        EasyTalkMessage.new(invalid_payload)
        false
      rescue ValidationError
        true
      end
    when :activemodel
      begin
        ActiveModelMessage.new(invalid_payload)
        false
      rescue ArgumentError, ActiveModel::ValidationError
        true
      end
    when :active_record
      begin
        ActiveRecordMessage.new(invalid_payload)
        false
      rescue ActiveRecord::RecordInvalid
        true
      end
    when :strong_parameters
      false
    when :strong_parameters_expect
      begin
        ActionController::Parameters.new(invalid_payload)
          .expect(:error, :message, details: { messages: [] })
        false
      rescue ActionController::ParameterMissing
        true
      end
    when :strong_parameters_permit_all
      false
    else
      begin
        case name
        when :dry_struct_plain
          DryStructPlainMessage.new(invalid_payload)
        when :sorbet_struct_plain
          SorbetPlainMessage.new(invalid_payload)
        when :easytalk_plain
          EasyTalkPlainMessage.new(invalid_payload)
        when :activemodel_plain
          ActiveModelPlainMessage.new(invalid_payload)
        end
        false
      rescue StandardError
        true
      end
    end
  end

  def error_class_name(name, invalid_payload)
    case name
    when :dry_validation
      "-"
    when :dry_struct
      begin
        DryStructMessage.new(invalid_payload)
        "-"
      rescue ValidationError => e
        e.class.name
      end
    when :sorbet_struct
      begin
        SorbetStructMessage.new(invalid_payload)
        "-"
      rescue ValidationError => e
        e.class.name
      end
    when :easytalk
      begin
        EasyTalkMessage.new(invalid_payload)
        "-"
      rescue ValidationError => e
        e.class.name
      end
    when :activemodel
      begin
        ActiveModelMessage.new(invalid_payload)
        "-"
      rescue ArgumentError, ActiveModel::ValidationError => e
        e.class.name
      end
    when :active_record
      begin
        ActiveRecordMessage.new(invalid_payload)
        "-"
      rescue ActiveRecord::RecordInvalid => e
        e.class.name
      end
    when :strong_parameters
      "-"
    when :strong_parameters_expect
      begin
        ActionController::Parameters.new(invalid_payload)
          .expect(:error, :message, details: { messages: [] })
        "-"
      rescue ActionController::ParameterMissing => e
        e.class.name
      end
    when :strong_parameters_permit_all
      "-"
    else
      begin
        case name
        when :dry_struct_plain
          DryStructPlainMessage.new(invalid_payload)
        when :sorbet_struct_plain
          SorbetPlainMessage.new(invalid_payload)
        when :easytalk_plain
          EasyTalkPlainMessage.new(invalid_payload)
        when :activemodel_plain
          ActiveModelPlainMessage.new(invalid_payload)
        end
        "-"
      rescue StandardError => e
        e.class.name
      end
    end
  end

  it "runs #{FAILED_ITERATIONS} failed validations for each approach" do
    results = {}
    invalid_payload = {
      error: 123,
      message: nil,
      details: { messages: [1] }
    }

    results[:dry_validation] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          DryValidataionMessage.new.(invalid_payload)
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          DryValidataionMessage.new.(invalid_payload)
        end
      end
    }

    results[:dry_struct] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            DryStructMessage.new(invalid_payload)
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            DryStructMessage.new(invalid_payload)
          end
        end
      end
    }

    results[:dry_struct_plain] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          begin
            DryStructPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          begin
            DryStructPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      end
    }

    results[:sorbet_struct] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            SorbetStructMessage.new(invalid_payload)
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            SorbetStructMessage.new(invalid_payload)
          end
        end
      end
    }

    results[:sorbet_struct_plain] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          begin
            SorbetPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          begin
            SorbetPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      end
    }

    results[:easytalk] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            EasyTalkMessage.new(invalid_payload)
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            EasyTalkMessage.new(invalid_payload)
          end
        end
      end
    }

    results[:easytalk_plain] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          begin
            EasyTalkPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          begin
            EasyTalkPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      end
    }

    results[:activemodel] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveModelMessage.new(invalid_payload)
          rescue ArgumentError, ActiveModel::ValidationError
            nil
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveModelMessage.new(invalid_payload)
          rescue ArgumentError, ActiveModel::ValidationError
            nil
          end
        end
      end
    }

    results[:activemodel_plain] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveModelPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveModelPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      end
    }

    results[:active_record] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveRecordMessage.new(invalid_payload)
          rescue ActiveRecord::RecordInvalid
            nil
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveRecordMessage.new(invalid_payload)
          rescue ActiveRecord::RecordInvalid
            nil
          end
        end
      end
    }

    results[:strong_parameters] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          ActionController::Parameters.new(invalid_payload)
            .permit(:error, :message, details: { messages: [] })
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          ActionController::Parameters.new(invalid_payload)
            .permit(:error, :message, details: { messages: [] })
        end
      end
    }

    results[:strong_parameters_expect] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          begin
            ActionController::Parameters.new(invalid_payload)
              .expect(:error, :message, details: { messages: [] })
          rescue ActionController::ParameterMissing
            nil
          end
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          begin
            ActionController::Parameters.new(invalid_payload)
              .expect(:error, :message, details: { messages: [] })
          rescue ActionController::ParameterMissing
            nil
          end
        end
      end
    }

    results[:strong_parameters_permit_all] = {
      time: Benchmark.realtime do
        run_validations(FAILED_ITERATIONS) do
          ActionController::Parameters.new(invalid_payload).permit!
        end
      end,
      mem: measure_memory do
        run_validations(FAILED_ITERATIONS) do
          ActionController::Parameters.new(invalid_payload).permit!
        end
      end
    }

    puts "\n== validation (failed, #{FAILED_ITERATIONS} iterations) =="
    puts format("%-30s %10s %12s %12s %20s", "name", "time(s)", "us/op", "bytes", "error")
    validates = {}
    error_classes = {}
    results.keys.each do |name|
      validates[name] = validation_triggered?(name, invalid_payload)
      error_classes[name] = error_class_name(name, invalid_payload)
    end

    results
      .sort_by { |_, data| data[:time] }
      .each do |name, data|
        if validates[name]
          us_per_op = (data[:time] * 1_000_000.0 / FAILED_ITERATIONS)
          puts format("%-30s %10.4f %12.2f %12d %20s", name, data[:time], us_per_op, data[:mem], error_classes[name])
        else
          puts format("%-30s %10s %12s %12s %20s", name, "-", "-", "-", error_classes[name])
        end
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

  it "profiles allocations for failed validations (MemoryProfiler, #{FAILED_ITERATIONS} iterations)" do
    invalid_payload = {
      error: 123,
      message: nil,
      details: { messages: [1] }
    }

    profiles = {
      dry_validation: -> {
        run_validations(FAILED_ITERATIONS) do
          DryValidataionMessage.new.(invalid_payload)
        end
      },
      dry_struct: -> {
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            DryStructMessage.new(invalid_payload)
          end
        end
      },
      dry_struct_plain: -> {
        run_validations(FAILED_ITERATIONS) do
          begin
            DryStructPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      },
      sorbet_struct: -> {
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            SorbetStructMessage.new(invalid_payload)
          end
        end
      },
      sorbet_struct_plain: -> {
        run_validations(FAILED_ITERATIONS) do
          begin
            SorbetPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      },
      easytalk: -> {
        run_validations(FAILED_ITERATIONS) do
          capture_validation_errors do
            EasyTalkMessage.new(invalid_payload)
          end
        end
      },
      easytalk_plain: -> {
        run_validations(FAILED_ITERATIONS) do
          begin
            EasyTalkPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      },
      activemodel: -> {
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveModelMessage.new(invalid_payload)
          rescue ArgumentError, ActiveModel::ValidationError
            nil
          end
        end
      },
      activemodel_plain: -> {
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveModelPlainMessage.new(invalid_payload)
          rescue StandardError
            nil
          end
        end
      },
      active_record: -> {
        run_validations(FAILED_ITERATIONS) do
          begin
            ActiveRecordMessage.new(invalid_payload)
          rescue ActiveRecord::RecordInvalid
            nil
          end
        end
      },
      strong_parameters: -> {
        run_validations(FAILED_ITERATIONS) do
          ActionController::Parameters.new(invalid_payload)
            .permit(:error, :message, details: { messages: [] })
        end
      },
      strong_parameters_expect: -> {
        run_validations(FAILED_ITERATIONS) do
          begin
            ActionController::Parameters.new(invalid_payload)
              .expect(:error, :message, details: { messages: [] })
          rescue ActionController::ParameterMissing
            nil
          end
        end
      },
      strong_parameters_permit_all: -> {
        run_validations(FAILED_ITERATIONS) do
          ActionController::Parameters.new(invalid_payload).permit!
        end
      }
    }

    validates = {}
    profiles.keys.each do |name|
      validates[name] = validation_triggered?(name, invalid_payload)
    end

    profile_reports = {}
    profiles.each do |name, fn|
      next unless validates[name]
      profile_reports[name] = MemoryProfiler.report { fn.call }
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
        puts "\n== #{name} (failed, #{FAILED_ITERATIONS} iterations) =="
        report.pretty_print(
          to_file: nil,
          scale_bytes: true,
          normalize_paths: true,
          detailed_report: false
        )
      end

    skipped = profiles.keys.reject { |name| validates[name] }
    if skipped.any?
      puts "\n== skipped (no validation on failure) =="
      skipped.sort.each { |name| puts name }
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
