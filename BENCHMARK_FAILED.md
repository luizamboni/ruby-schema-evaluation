# Failed Validation Benchmark

Run: `bundle exec rspec spec/benchmark_failed_spec.rb`
Iterations: 10_000

## Failed validation (invalid payload)
| name | time(s) | us/op | bytes | error |
| --- | --- | --- | --- | --- |
| activemodel_plain | - | - | - | - |
| easytalk | 0.0395 | 3.95 | 0 | ValidationError |
| easytalk_plain | - | - | - | - |
| sorbet_struct | 0.0590 | 5.90 | 2296 | ValidationError |
| dry_struct | 0.0615 | 6.15 | 2296 | ValidationError |
| dry_struct_plain | 0.2128 | 21.28 | 0 | Dry::Struct::Error |
| sorbet_struct_plain | 0.2182 | 21.82 | -40 | TypeError |
| activemodel | 1.2565 | 125.65 | 0 | ActiveModel::ValidationError |
| dry_validation | 1.3785 | 137.85 | 0 | - |

## MemoryProfiler (allocations)
| name | total allocated |
| --- | --- |
| easytalk | 24.96 MB (160000 objects) |
| dry_struct | 33.36 MB (260002 objects) |
| sorbet_struct | 33.76 MB (320001 objects) |
| dry_struct_plain | 157.18 MB (1000000 objects) |
| sorbet_struct_plain | 219.26 MB (1170000 objects) |
| activemodel | 354.27 MB (3520002 objects) |
| dry_validation | 504.24 MB (5860000 objects) |
| easytalk_plain | - |
| activemodel_plain | - |

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
