# Failed Validation Benchmark (StrongParameters permit!)

Run: `bundle exec rspec spec/benchmark_failed_spec.rb`
Date: 2026-01-30
Ruby: 3.3.0 (RVM)
Iterations: 10_000

## Failed validation (invalid payload)
| name | time(s) | us/op | bytes | error |
| --- | --- | --- | --- | --- |
| activemodel_plain | - | - | - | - |
| easytalk | 0.0401 | 4.01 | 2216 | ValidationError |
| easytalk_plain | - | - | - | - |
| sorbet_struct | 0.0612 | 6.12 | 2296 | ValidationError |
| dry_struct | 0.0635 | 6.35 | 2296 | ValidationError |
| strong_parameters_permit_all | - | - | - | - |
| sorbet_struct_plain | 0.1972 | 19.72 | 13247 | TypeError |
| dry_struct_plain | 0.1986 | 19.86 | 0 | Dry::Struct::Error |
| strong_parameters | - | - | - | - |
| activemodel | 1.2310 | 123.10 | 4296 | ActiveModel::ValidationError |
| dry_validation | 1.2995 | 129.95 | 0 | - |

## MemoryProfiler (allocations)
| name | total allocated |
| --- | --- |
| easytalk | 27.36 MB (180000 objects) |
| dry_struct | 34.16 MB (260002 objects) |
| sorbet_struct | 36.16 MB (340001 objects) |
| dry_struct_plain | 157.18 MB (1000000 objects) |
| sorbet_struct_plain | 219.26 MB (1170000 objects) |
| activemodel | 353.47 MB (3500002 objects) |
| dry_validation | 504.24 MB (5860000 objects) |
| easytalk_plain | - |
| activemodel_plain | - |
| strong_parameters | - |
| strong_parameters_permit_all | - |

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
