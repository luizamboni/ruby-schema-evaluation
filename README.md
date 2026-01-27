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

This repo is a comparative study of Ruby DTO/schema approaches under different validation strategies and error‑handling styles. It benchmarks correctness behavior, performance, and memory usage across multiple libraries and custom enforcers.

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

## How to run
```
bundle exec rspec
```

## Benchmarks
- Happy‑path: `bundle exec rspec spec/benchmark_spec.rb`
- Failure‑path: `bundle exec rspec spec/benchmark_failed_spec.rb`

Results are captured in the `BENCHMARK_*.md` files.

### Happy‑path reports
1. [BENCHMARK_INITIAL.md](BENCHMARK_INITIAL.md)
2. [BENCHMARK_DIFF.md](BENCHMARK_DIFF.md)
3. [BENCHMARK_DIFF_LIGHTWEIGHT_ERRORS.md](BENCHMARK_DIFF_LIGHTWEIGHT_ERRORS.md)
4. [BENCHMARK_DIFF_FASTPATH_EASYTALK.md](BENCHMARK_DIFF_FASTPATH_EASYTALK.md)
5. [BENCHMARK_DIFF_FAST_ARRAY_VALIDATION.md](BENCHMARK_DIFF_FAST_ARRAY_VALIDATION.md)

### Failure‑path reports
1. [BENCHMARK_FAILED.md](BENCHMARK_FAILED.md)
2. [BENCHMARK_FAILED_DIFF_LIGHTWEIGHT_ERRORS.md](BENCHMARK_FAILED_DIFF_LIGHTWEIGHT_ERRORS.md)
3. [BENCHMARK_FAILED_DIFF_FASTPATH_EASYTALK.md](BENCHMARK_FAILED_DIFF_FASTPATH_EASYTALK.md)
4. [BENCHMARK_FAILED_DIFF_FAST_ARRAY_VALIDATION.md](BENCHMARK_FAILED_DIFF_FAST_ARRAY_VALIDATION.md)
