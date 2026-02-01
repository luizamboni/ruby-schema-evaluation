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


## Plain vs extended DTOs
The repo defines two variants per library:
- Plain DTOs: baseline library behavior with minimal additions.
- Extended DTOs: wrap the same schema with custom enforcers for stricter validation, richer errors, nested initializations, and some performance tweaks.

## Unexpected fields (DTO input)
Behavior when callers pass extra properties that are not defined in the DTO schema (top-level or nested):

| DTO / Validator | Top-level unknowns | Nested unknowns |
| --- | --- | --- |
| Dry::Validation | ignored | ignored |
| Dry::Struct | ignored | ignored |
| Sorbet T::Struct | raises `ValidationError` (`is not permitted`) | raises `ValidationError` (`is not permitted`) |
| EasyTalk (SchemaEnforcer) | raises `ActiveModel::UnknownAttributeError` | raises `ActiveModel::UnknownAttributeError` |
| ActiveModel | raises `ActiveModel::UnknownAttributeError` | raises `ActiveModel::UnknownAttributeError` |


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
| Date | Commit | Category | What it measures | Report |
| --- | --- | --- | --- | --- |
| 2026-01-25 | af433e4 | Baseline happy-path | Construct + validate + serialize costs | [Initial](BENCHMARK_INITIAL.md) |
| 2026-01-25 | c2a4c62 | Diff (schema cache) | Change vs baseline after memoization | [Diff (schema cache)](BENCHMARK_DIFF.md) |
| 2026-01-25 | 117120e | Diff (lightweight errors) | Change vs baseline with lightweight errors | [Diff (lightweight errors)](BENCHMARK_DIFF_LIGHTWEIGHT_ERRORS.md) |
| 2026-01-25 | fd8f402 | Diff (EasyTalk fast-path) | Change vs baseline with fast-path | [Diff (EasyTalk fast-path)](BENCHMARK_DIFF_FASTPATH_EASYTALK.md) |
| 2026-01-25 | 3e8f2fb | Diff (fast array validation) | Change vs baseline with array fast-path | [Diff (fast array validation)](BENCHMARK_DIFF_FAST_ARRAY_VALIDATION.md) |
| 2026-01-25 | 182692d | Baseline failure-path | Invalid payload cost and allocations | [Failed](BENCHMARK_FAILED.md) |
| 2026-01-25 | 117120e | Failure diff (lightweight errors) | Change vs failed baseline | [Failed diff (lightweight errors)](BENCHMARK_FAILED_DIFF_LIGHTWEIGHT_ERRORS.md) |
| 2026-01-25 | fd8f402 | Failure diff (EasyTalk fast-path) | Change vs failed baseline | [Failed diff (EasyTalk fast-path)](BENCHMARK_FAILED_DIFF_FASTPATH_EASYTALK.md) |
| 2026-01-25 | fd8f402 | Failure diff (fast array validation) | Change vs failed baseline | [Failed diff (fast array validation)](BENCHMARK_FAILED_DIFF_FAST_ARRAY_VALIDATION.md) |
| 2026-02-01 | 63f31ab | Attribute access | Reader cost per DTO | [Attribute access (2026-02-01)](BENCHMARK_ATTRIBUTE_ACCESS_2026-02-01.md) |

## Rails params benchmarks
These benchmarks simulate the full Rails controller parameter pipeline before DTO construction.

### Pipelines covered
| Date | Commit | Category | What it measures | Report |
| --- | --- | --- | --- | --- |
| 2026-01-31 | f5c2f11 | Strong Parameters + DTO | `require/permit` or `expect` + DTO | [Rails params (permit/expect) 2026-01-30](BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-01-30.md) |
| 2026-02-01 | acaed13 | Request params + DTO | `request_parameters` + `deep_symbolize_keys` + DTO | [Rails params (request/to_unsafe_h) 2026-02-01](BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-02-01.md) |
| 2026-02-01 | acaed13 | Unsafe hash + DTO | `to_unsafe_h` + DTO | [Rails params (request/to_unsafe_h) 2026-02-01](BENCHMARK_INITIAL_RAILS_PARAMS_COMPARISON_2026-02-01.md) |

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
  # Raw body params; symbolize keys for DTO initialization.
  raw = request.request_parameters.deep_symbolize_keys
  dto = EasyTalkMessage.new(raw)
  render json: dto
end
```

Unsafe hash + DTO:
```ruby
def create
  # Unfiltered params; acceptable here because DTO enforces schema
  raw = params.to_unsafe_h
  dto = ActiveModelMessage.new(raw)
  render json: dto
end
```

## Attribute access benchmark
This benchmark measures the cost of reading attributes from DTO instances across implementations.

| Date | Commit | Category | What it measures | Report |
| --- | --- | --- | --- | --- |
| 2026-02-01 | 63f31ab | Attribute access | Reader cost across DTOs | [Attribute access (2026-02-01)](BENCHMARK_ATTRIBUTE_ACCESS_2026-02-01.md) |
