# Rails Params + DTO Comparison

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: 2026-01-31
Ruby: 3.3.0 (RVM)
Rails: 8.1.2
Iterations: 10_000

## Validation
| dto | time(s) | us/op | bytes | validates types | comments |
| --- | --- | --- | --- | --- | --- |
| sorbet_struct_plain | 0.1589 | 15.89 | 32 | Yes | rails params + permit! + dto |
| dry_struct_plain | 0.1737 | 17.37 | 0 | Yes | rails params + permit! + dto |
| activemodel_no_enforcement | 0.1911 | 19.11 | 0 | No | rails params + permit! + dto |
| sorbet_struct | 0.1983 | 19.83 | 0 | Yes | rails params + permit! + dto |
| easytalk_plain | 0.2026 | 20.26 | 32 | Yes | rails params + permit! + dto |
| activemodel_plain | 0.2236 | 22.36 | 32 | No | rails params + permit! + dto |
| dry_struct | 0.2250 | 22.50 | 0 | Yes | rails params + permit! + dto |
| easytalk | 0.2651 | 26.51 | 480 | Yes | rails params + permit! + dto |
| active_record | 0.3015 | 30.15 | 0 | Yes | rails params + permit! + dto |
| activemodel | 0.3155 | 31.55 | 0 | Yes | rails params + permit! + dto |
| rails params + expect | 0.3537 | 35.37 | 40 | No | no DTO |
| dry_validation | 0.3821 | 38.21 | 0 | Yes | rails params + permit! + dto |
| rails params + require + permit | 0.4384 | 43.84 | 0 | No | no DTO |

## MemoryProfiler
| dto | total allocated | objects | validates types | comments |
| --- | --- | --- | --- | --- |
| sorbet_struct_plain | 36.80 MB | 450000 | Yes | rails params + permit! + dto |
| dry_struct_plain | 37.20 MB | 460000 | Yes | rails params + permit! + dto |
| sorbet_struct | 40.40 MB | 590000 | Yes | rails params + permit! + dto |
| dry_struct | 42.80 MB | 570000 | Yes | rails params + permit! + dto |
| easytalk_plain | 48.40 MB | 610000 | Yes | rails params + permit! + dto |
| activemodel_plain | 49.60 MB | 630000 | No | rails params + permit! + dto |
| activemodel_no_enforcement | 49.60 MB | 630028 | No | rails params + permit! + dto |
| easytalk | 50.40 MB | 770000 | Yes | rails params + permit! + dto |
| active_record | 51.20 MB | 690000 | Yes | rails params + permit! + dto |
| activemodel | 58.00 MB | 900000 | Yes | rails params + permit! + dto |
| dry_validation | 65.92 MB | 860000 | Yes | rails params + permit! + dto |
| rails params + expect | 80.24 MB | 1040000 | No | no DTO |
| rails params + require + permit | 85.04 MB | 1060000 | No | no DTO |

## Failed Validation
| dto | time(s) | us/op | bytes | validates types | comments |
| --- | --- | --- | --- | --- | --- |
| activemodel_plain | 0.1679 | 16.79 | -80 | No | rails params + permit! + dto |
| activemodel_no_enforcement | 0.1687 | 16.87 | 0 | No | rails params + permit! + dto |
| easytalk | 0.1842 | 18.42 | 0 | Yes | rails params + permit! + dto |
| easytalk_plain | 0.2046 | 20.46 | 0 | Yes | rails params + permit! + dto |
| sorbet_struct | 0.2102 | 21.02 | 0 | Yes | rails params + permit! + dto |
| dry_struct | 0.2137 | 21.37 | 2296 | Yes | rails params + permit! + dto |
| rails params + expect | 0.2703 | 27.03 | 1896 | No | no DTO |
| rails params + require + permit | 0.2982 | 29.82 | -360 | No | no DTO |
| sorbet_struct_plain | 0.3629 | 36.29 | 0 | Yes | rails params + permit! + dto |
| dry_struct_plain | 0.3635 | 36.35 | 11974 | Yes | rails params + permit! + dto |
| active_record | 0.9923 | 99.23 | 3976 | Yes | rails params + permit! + dto |
| activemodel | 1.4745 | 147.45 | 4576 | Yes | rails params + permit! + dto |
| dry_validation | 1.6150 | 161.50 | 0 | Yes | rails params + permit! + dto |

## Failed MemoryProfiler
| dto | total allocated | objects | validates types | comments |
| --- | --- | --- | --- | --- |
| activemodel_plain | 38.40 MB | 520000 | No | rails params + permit! + dto |
| activemodel_no_enforcement | 38.40 MB | 520000 | No | rails params + permit! + dto |
| easytalk_plain | 42.40 MB | 580000 | Yes | rails params + permit! + dto |
| easytalk | 56.96 MB | 570000 | Yes | rails params + permit! + dto |
| dry_struct | 63.76 MB | 650002 | Yes | rails params + permit! + dto |
| sorbet_struct | 65.76 MB | 730001 | Yes | rails params + permit! + dto |
| rails params + require + permit | 85.04 MB | 1060000 | No | no DTO |
| rails params + expect | 90.00 MB | 980000 | No | no DTO |
| dry_struct_plain | 186.78 MB | 1390000 | Yes | rails params + permit! + dto |
| active_record | 228.08 MB | 2370000 | Yes | rails params + permit! + dto |
| sorbet_struct_plain | 248.86 MB | 1560028 | Yes | rails params + permit! + dto |
| activemodel | 383.87 MB | 3910002 | Yes | rails params + permit! + dto |
| dry_validation | 533.84 MB | 6250000 | Yes | rails params + permit! + dto |


Notes:
- All cases use the same payload shape.
