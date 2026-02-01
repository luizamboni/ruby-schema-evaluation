# Rails Params + DTO Comparison (Permit!/to_unsafe_h)

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: 2026-02-01
Ruby: 3.3.0 (RVM)
Rails: 8.1.2
Iterations: 10_000

## Validation
| dto | time(s) | us/op | bytes | validates types | comments |
| --- | --- | --- | --- | --- | --- |
| sorbet_struct_plain_unsafe_h | 0.1095 | 10.95 | 640 | Yes | rails params + to_unsafe_h + dto |
| dry_struct_plain_unsafe_h | 0.1222 | 12.22 | 384 | Yes | rails params + to_unsafe_h + dto |
| activemodel_plain_unsafe_h | 0.1380 | 13.80 | 384 | Yes | rails params + to_unsafe_h + dto |
| activemodel_no_enforcement_unsafe_h | 0.1386 | 13.86 | 384 | Yes | rails params + to_unsafe_h + dto |
| easytalk_plain_unsafe_h | 0.1517 | 15.17 | 640 | Yes | rails params + to_unsafe_h + dto |
| sorbet_struct_unsafe_h | 0.1564 | 15.64 | 192 | Yes | rails params + to_unsafe_h + dto |
| sorbet_struct_plain | 0.1668 | 16.68 | 0 | Yes | rails params + permit! + dto |
| dry_struct_unsafe_h | 0.1735 | 17.35 | 192 | Yes | rails params + to_unsafe_h + dto |
| dry_struct_plain | 0.1791 | 17.91 | 0 | Yes | rails params + permit! + dto |
| activemodel_plain | 0.1948 | 19.48 | 0 | No | rails params + permit! + dto |
| activemodel_no_enforcement | 0.1951 | 19.51 | 0 | No | rails params + permit! + dto |
| easytalk_plain | 0.2088 | 20.88 | 0 | Yes | rails params + permit! + dto |
| sorbet_struct | 0.2145 | 21.45 | 0 | Yes | rails params + permit! + dto |
| dry_struct | 0.2304 | 23.04 | 0 | Yes | rails params + permit! + dto |
| easytalk_unsafe_h | 0.2436 | 24.36 | 192 | Yes | rails params + to_unsafe_h + dto |
| active_record_unsafe_h | 0.2440 | 24.40 | 192 | Yes | rails params + to_unsafe_h + dto |
| activemodel_unsafe_h | 0.2665 | 26.65 | 192 | Yes | rails params + to_unsafe_h + dto |
| easytalk | 0.2748 | 27.48 | 0 | Yes | rails params + permit! + dto |
| active_record | 0.3070 | 30.70 | 1560 | Yes | rails params + permit! + dto |
| activemodel | 0.3274 | 32.74 | 0 | Yes | rails params + permit! + dto |
| dry_validation_unsafe_h | 0.3538 | 35.38 | 1856 | Yes | rails params + to_unsafe_h + dto |
| dry_validation | 0.4701 | 47.01 | 160 | Yes | rails params + permit! + dto |
| rails params + require + permit | 0.5020 | 50.20 | 0 | No | no DTO |
| rails params + expect | 0.5460 | 54.60 | 40 | No | no DTO |

## MemoryProfiler
| dto | total allocated | objects | validates types | comments |
| --- | --- | --- | --- | --- |
| sorbet_struct_plain_unsafe_h | 26.80 MB | 270000 | Yes | rails params + to_unsafe_h + dto |
| dry_struct_plain_unsafe_h | 27.20 MB | 280000 | Yes | rails params + to_unsafe_h + dto |
| sorbet_struct_unsafe_h | 30.40 MB | 410000 | Yes | rails params + to_unsafe_h + dto |
| dry_struct_unsafe_h | 32.80 MB | 390000 | Yes | rails params + to_unsafe_h + dto |
| sorbet_struct_plain | 36.80 MB | 450000 | Yes | rails params + permit! + dto |
| dry_struct_plain | 37.20 MB | 460000 | Yes | rails params + permit! + dto |
| easytalk_plain_unsafe_h | 38.40 MB | 430028 | Yes | rails params + to_unsafe_h + dto |
| activemodel_no_enforcement_unsafe_h | 39.60 MB | 450000 | Yes | rails params + to_unsafe_h + dto |
| activemodel_plain_unsafe_h | 39.60 MB | 450000 | Yes | rails params + to_unsafe_h + dto |
| sorbet_struct | 40.40 MB | 590000 | Yes | rails params + permit! + dto |
| easytalk_unsafe_h | 40.40 MB | 590000 | Yes | rails params + to_unsafe_h + dto |
| active_record_unsafe_h | 41.20 MB | 510000 | Yes | rails params + to_unsafe_h + dto |
| dry_struct | 42.80 MB | 570000 | Yes | rails params + permit! + dto |
| activemodel_unsafe_h | 48.00 MB | 720000 | Yes | rails params + to_unsafe_h + dto |
| easytalk_plain | 48.40 MB | 610000 | Yes | rails params + permit! + dto |
| activemodel_plain | 49.60 MB | 630000 | No | rails params + permit! + dto |
| activemodel_no_enforcement | 49.60 MB | 630000 | No | rails params + permit! + dto |
| easytalk | 50.40 MB | 770000 | Yes | rails params + permit! + dto |
| active_record | 51.20 MB | 690000 | Yes | rails params + permit! + dto |
| dry_validation_unsafe_h | 55.92 MB | 680000 | Yes | rails params + to_unsafe_h + dto |
| activemodel | 58.00 MB | 900000 | Yes | rails params + permit! + dto |
| dry_validation | 65.92 MB | 860000 | Yes | rails params + permit! + dto |
| rails params + expect | 80.24 MB | 1040000 | No | no DTO |
| rails params + require + permit | 85.04 MB | 1060000 | No | no DTO |

## Failed Validation
Not run in this report.

## Failed MemoryProfiler
Not run in this report.

Notes:
- All cases use the same payload shape.
- Order rows by best performance (lowest time(s) for Validation, lowest total allocated for MemoryProfiler).
