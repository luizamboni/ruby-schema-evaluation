# Rails Params + DTO Comparison

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: YYYY-MM-DD
Ruby: X.Y.Z (RVM)
Rails: X.Y.Z
Iterations: 10_000

## Validation
| dto | time(s) | us/op | bytes | comments |
| --- | --- | --- | --- | --- |
| sorbet_struct_plain | | | | rails params + permit! + dto |
| dry_struct_plain | | | | rails params + permit! + dto |
| activemodel_plain | | | | rails params + permit! + dto |
| easytalk_plain | | | | rails params + permit! + dto |
| sorbet_struct | | | | rails params + permit! + dto |
| dry_struct | | | | rails params + permit! + dto |
| easytalk | | | | rails params + permit! + dto |
| rails params + expect | | | | no DTO |
| rails params + require + permit | | | | no DTO |
| activemodel | | | | rails params + permit! + dto |
| active_record | | | | rails params + permit! + dto |
| dry_validation | | | | rails params + permit! + dto |

## MemoryProfiler
| dto | total allocated | objects | comments |
| --- | --- | --- | --- |
| sorbet_struct_plain | | | rails params + permit! + dto |
| dry_struct_plain | | | rails params + permit! + dto |
| sorbet_struct | | | rails params + permit! + dto |
| dry_struct | | | rails params + permit! + dto |
| easytalk_plain | | | rails params + permit! + dto |
| activemodel_plain | | | rails params + permit! + dto |
| easytalk | | | rails params + permit! + dto |
| active_record | | | rails params + permit! + dto |
| activemodel | | | rails params + permit! + dto |
| dry_validation | | | rails params + permit! + dto |
| rails params + expect | | | no DTO |
| rails params + require + permit | | | no DTO |

Notes:
- All cases use the same payload shape.
- Order rows by best performance (lowest time(s) for Validation, lowest total allocated for MemoryProfiler).
