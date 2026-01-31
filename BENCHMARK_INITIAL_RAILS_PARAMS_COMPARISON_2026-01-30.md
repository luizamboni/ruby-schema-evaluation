# Rails Params + DTO Comparison

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: 2026-01-30
Ruby: 3.3.0 (RVM)
Rails: 8.1.2
Iterations: 10_000

## Validation
| dto | time(s) | us/op | bytes | comments |
| --- | --- | --- | --- | --- |
| sorbet_struct_plain | 0.1668 | 16.68 | 0 | rails params + permit! + dto |
| dry_struct_plain | 0.1813 | 18.13 | 0 | rails params + permit! + dto |
| activemodel_plain | 0.1999 | 19.99 | 0 | rails params + permit! + dto |
| easytalk_plain | 0.2085 | 20.85 | 0 | rails params + permit! + dto |
| sorbet_struct | 0.2113 | 21.13 | 0 | rails params + permit! + dto |
| dry_struct | 0.2596 | 25.96 | 0 | rails params + permit! + dto |
| easytalk | 0.2792 | 27.92 | 0 | rails params + permit! + dto |
| rails params + expect | 0.3036 | 30.36 | 40 | no DTO |
| rails params + require + permit | 0.3182 | 31.82 | 0 | no DTO |
| activemodel | 0.3282 | 32.82 | 0 | rails params + permit! + dto |
| active_record | 0.3533 | 35.33 | 1560 | rails params + permit! + dto |
| dry_validation | 0.4566 | 45.66 | 160 | rails params + permit! + dto |

## MemoryProfiler
| dto | total allocated | objects | comments |
| --- | --- | --- | --- |
| sorbet_struct_plain | 36.80 MB | 450000 | rails params + permit! + dto |
| dry_struct_plain | 37.20 MB | 460000 | rails params + permit! + dto |
| sorbet_struct | 40.40 MB | 590000 | rails params + permit! + dto |
| dry_struct | 42.80 MB | 570000 | rails params + permit! + dto |
| easytalk_plain | 48.40 MB | 610000 | rails params + permit! + dto |
| activemodel_plain | 49.60 MB | 630000 | rails params + permit! + dto |
| easytalk | 50.40 MB | 770000 | rails params + permit! + dto |
| active_record | 51.20 MB | 690000 | rails params + permit! + dto |
| activemodel | 58.00 MB | 900000 | rails params + permit! + dto |
| dry_validation | 65.92 MB | 860000 | rails params + permit! + dto |
| rails params + expect | 80.24 MB | 1040000 | no DTO |
| rails params + require + permit | 85.04 MB | 1060000 | no DTO |


Notes:
- All cases use the same payload shape.
