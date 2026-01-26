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
