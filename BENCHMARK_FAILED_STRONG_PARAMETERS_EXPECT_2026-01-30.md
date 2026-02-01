# Failed Validation Benchmark (StrongParameters expect)

Run: `bundle exec rspec spec/benchmark_failed_spec.rb`
Date: 2026-01-30
Ruby: 3.3.0 (RVM)
Rails: 8.1.2
Iterations: 10_000

## Failed validation (invalid payload)
| name | time(s) | us/op | bytes | error |
| --- | --- | --- | --- | --- |
| activemodel_plain | - | - | - | - |
| easytalk | 0.0700 | 7.00 | 0 | ValidationError |
| dry_struct | 0.0707 | 7.07 | 0 | ValidationError |
| strong_parameters_permit_all | - | - | - | - |
| easytalk_plain | - | - | - | - |
| sorbet_struct | 0.0904 | 9.04 | 0 | ValidationError |
| dry_struct_plain | 0.2074 | 20.74 | 0 | Dry::Struct::Error |
| strong_parameters | - | - | - | - |
| strong_parameters_expect | 0.2828 | 28.28 | 1968 | ActionController::ParameterMissing |
| sorbet_struct_plain | 0.3672 | 36.72 | 13207 | TypeError |
| active_record | 0.7331 | 73.31 | 3776 | ActiveRecord::RecordInvalid |
| activemodel | 1.3503 | 135.03 | 4376 | ActiveModel::ValidationError |
| dry_validation | 1.8259 | 182.59 | 0 | - |

## MemoryProfiler (allocations)
| name | total allocated |
| --- | --- |
| easytalk | 27.36 MB (180028 objects) |
| dry_struct | 34.16 MB (260002 objects) |
| sorbet_struct | 36.16 MB (340001 objects) |
| strong_parameters_expect | 90.00 MB (980000 objects) |
| dry_struct_plain | 157.18 MB (1000000 objects) |
| active_record | 198.48 MB (1980000 objects) |
| sorbet_struct_plain | 219.26 MB (1170000 objects) |
| activemodel | 354.27 MB (3520002 objects) |
| dry_validation | 504.24 MB (5860000 objects) |
| easytalk_plain | - |
| activemodel_plain | - |
| strong_parameters | - |
| strong_parameters_permit_all | - |

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
