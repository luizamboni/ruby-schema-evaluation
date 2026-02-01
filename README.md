# Ruby Schema Evaluation

## Example behavior
```ruby
# A valid payload should build cleanly
payload = {
  error: "NOT_FOUND",
  message: "missing",
  details: { messages: ["ok"] }
}

message = RubyDTOExample.new(payload)

# An invalid payload should raise a ValidationError
bad_payload = {
  error: 123,
  message: nil,
  details: { messages: [1] }
}

begin
  RubyDTOExample.new(bad_payload)
rescue ValidationError => e
  puts e.errors # => { "error"=>["must be a string (got Integer)"], ... }
end
```

This repo is a comparative study of Ruby DTO/schema approaches under different validation strategies and error-handling styles. It benchmarks correctness behavior, performance, and memory usage across multiple libraries and custom enforcers.

If you are evaluating Ruby schema/DTO libraries, comparing validation ergonomics, or tuning validation performance, this repo is for you.

## Unexpected fields (DTO input)
Behavior when callers pass extra properties that are not defined in the DTO schema (top-level or nested):

| DTO / Validator | Top-level unknowns | Nested unknowns |
| --- | --- | --- |
| Dry::Validation | ignored | ignored |
| Dry::Struct | ignored | ignored |
| Sorbet T::Struct | raises `ValidationError` (`is not permitted`) | raises `ValidationError` (`is not permitted`) |
| EasyTalk (SchemaEnforcer) | raises `ActiveModel::UnknownAttributeError` | raises `ActiveModel::UnknownAttributeError` |
| ActiveModel | raises `ActiveModel::UnknownAttributeError` | raises `ActiveModel::UnknownAttributeError` |

## Goals
- Compare validation behavior across approaches (happy path and failure path).
- Measure performance (time) and memory allocations.
- Explore optimizations (e.g., schema caching, lazy error creation, fast‑path validations).
- Document trade‑offs between strictness, ergonomics, and runtime cost.

## What’s inside
- Multiple DTO implementations in `spec/support/messages/` (Dry::Struct, Sorbet, EasyTalk, ActiveModel, Dry::Validation).
- Benchmarks and comparison specs in `spec/`.
- Baseline benchmark results in `BENCHMARK_INITIAL.md`.
- Follow‑up diff reports (`BENCHMARK_DIFF*.md`, `BENCHMARK_FAILED*.md`) showing the impact of specific optimizations.

## Plain vs extended DTOs
The repo defines two variants per library:
- Plain DTOs: baseline library behavior with minimal additions.
- Extended DTOs: wrap the same schema with custom enforcers for stricter validation, richer errors, and some performance tweaks.

Where to find them:
- Plain classes live in `spec/support/messages/plain_messages.rb`.
- Extended classes live in `spec/support/messages/dry_struct_message.rb`, `spec/support/messages/sorbet_struct_message.rb`, `spec/support/messages/easy_talk_message.rb`, and `spec/support/messages/active_model_message.rb`.

What changes in the extended versions (high level):
- Custom validation flow that raises `ValidationError` with structured error hashes.
- Explicit type checking/coercion on nested objects and arrays.
- Optional fast-path validation for arrays and cached schema metadata in some enforcers.

## Quick start
Requirements:
- Ruby (see `.ruby-version` if present)
- Bundler

Install and run:
```
bundle install
bundle exec rspec
```

## How to run
```
bundle exec rspec
```

## Benchmarks
- Happy‑path: `bundle exec rspec spec/benchmark_spec.rb`
- Failure‑path: `bundle exec rspec spec/benchmark_failed_spec.rb`

Results are captured in the `BENCHMARK_*.md` files.

### Benchmark index
| Category | What it measures | Report |
| --- | --- | --- |
| Baseline happy-path | Construct + validate + serialize costs | [BENCHMARK_INITIAL.md](BENCHMARK_INITIAL.md) |
| Diff (schema cache) | Change vs baseline after memoization | [BENCHMARK_DIFF.md](BENCHMARK_DIFF.md) |
| Diff (lightweight errors) | Change vs baseline with lightweight errors | [BENCHMARK_DIFF_LIGHTWEIGHT_ERRORS.md](BENCHMARK_DIFF_LIGHTWEIGHT_ERRORS.md) |
| Diff (EasyTalk fast-path) | Change vs baseline with fast-path | [BENCHMARK_DIFF_FASTPATH_EASYTALK.md](BENCHMARK_DIFF_FASTPATH_EASYTALK.md) |
| Diff (fast array validation) | Change vs baseline with array fast-path | [BENCHMARK_DIFF_FAST_ARRAY_VALIDATION.md](BENCHMARK_DIFF_FAST_ARRAY_VALIDATION.md) |
| Baseline failure-path | Invalid payload cost and allocations | [BENCHMARK_FAILED.md](BENCHMARK_FAILED.md) |
| Failure diff (lightweight errors) | Change vs failed baseline | [BENCHMARK_FAILED_DIFF_LIGHTWEIGHT_ERRORS.md](BENCHMARK_FAILED_DIFF_LIGHTWEIGHT_ERRORS.md) |
| Failure diff (EasyTalk fast-path) | Change vs failed baseline | [BENCHMARK_FAILED_DIFF_FASTPATH_EASYTALK.md](BENCHMARK_FAILED_DIFF_FASTPATH_EASYTALK.md) |
| Failure diff (fast array validation) | Change vs failed baseline | [BENCHMARK_FAILED_DIFF_FAST_ARRAY_VALIDATION.md](BENCHMARK_FAILED_DIFF_FAST_ARRAY_VALIDATION.md) |
| Attribute access | Reader cost per DTO | [BENCHMARK_ATTRIBUTE_ACCESS_2026-02-01.md](BENCHMARK_ATTRIBUTE_ACCESS_2026-02-01.md) |

## Rails params benchmarks
These benchmarks simulate the full Rails controller parameter pipeline before DTO construction.

### Pipelines covered
| Category | What it measures | Report |
| --- | --- | --- |
| Strong Parameters + DTO | `require/permit` or `expect` + DTO | [BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-01-30.md](BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-01-30.md) |
| Request params + DTO | `request_parameters` + `deep_symbolize_keys` + DTO | [BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-02-01.md](BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-02-01.md) |
| Unsafe hash + DTO | `to_unsafe_h` + DTO | [BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-02-01.md](BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-02-01.md) |

### Controller-style examples
Strong Parameters + DTO (permit!/require):
```ruby
def create
  permitted = params.require(:message).permit(:error, :message, details: [:messages])
  dto = DryStructMessage.new(permitted.to_h)
  render json: dto
end
```

Strong Parameters + DTO (expect):
```ruby
def create
  permitted = params.expect(message: [:error, :message, { details: [:messages] }])
  dto = SorbetStructMessage.new(permitted.to_h)
  render json: dto
end
```

Request params + deep_symbolize_keys + DTO:
```ruby
def create
  raw = request.request_parameters.deep_symbolize_keys
  dto = EasyTalkMessage.new(raw)
  render json: dto
end
```

Unsafe hash + DTO:
```ruby
def create
  raw = params.to_unsafe_h
  dto = ActiveModelMessage.new(raw)
  render json: dto
end
```

## Attribute access benchmark
This benchmark measures the cost of reading attributes from DTO instances across implementations.

| Category | What it measures | Report |
| --- | --- | --- |
| Attribute access | Reader cost across DTOs | [BENCHMARK_ATTRIBUTE_ACCESS_2026-02-01.md](BENCHMARK_ATTRIBUTE_ACCESS_2026-02-01.md) |

## Adding a new DTO/validator
1. Add the DTO implementation in `spec/support/messages/`.
2. Add or extend specs in `spec/` to exercise both happy and failure paths.
3. Run the relevant benchmarks and record outputs in a new `BENCHMARK_*.md` file.
