# Rails Params + DTO Comparison

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: YYYY-MM-DD
Ruby: X.Y.Z (RVM)
Rails: X.Y.Z
Iterations: 10_000

## Validation
| dto | time(s) | us/op | bytes | validates types | comments |
| --- | --- | --- | --- | --- | --- |
| sorbet_struct_plain | | | | Yes | rails params + permit! + dto |
| dry_struct_plain | | | | Yes | rails params + permit! + dto |
| activemodel_no_enforcement | | | | No | rails params + permit! + dto |
| activemodel_plain | | | | No | rails params + permit! + dto |
| easytalk_plain | | | | Yes | rails params + permit! + dto |
| sorbet_struct | | | | Yes | rails params + permit! + dto |
| dry_struct | | | | Yes | rails params + permit! + dto |
| easytalk | | | | Yes | rails params + permit! + dto |
| rails params + expect | | | | No | no DTO |
| rails params + require + permit | | | | No | no DTO |
| activemodel | | | | Yes | rails params + permit! + dto |
| active_record | | | | Yes | rails params + permit! + dto |
| dry_validation | | | | Yes | rails params + permit! + dto |

## MemoryProfiler
| dto | total allocated | objects | validates types | comments |
| --- | --- | --- | --- | --- |
| sorbet_struct_plain | | | Yes | rails params + permit! + dto |
| dry_struct_plain | | | Yes | rails params + permit! + dto |
| sorbet_struct | | | Yes | rails params + permit! + dto |
| dry_struct | | | Yes | rails params + permit! + dto |
| easytalk_plain | | | Yes | rails params + permit! + dto |
| activemodel_plain | | | No | rails params + permit! + dto |
| activemodel_no_enforcement | | | No | rails params + permit! + dto |
| easytalk | | | Yes | rails params + permit! + dto |
| active_record | | | Yes | rails params + permit! + dto |
| activemodel | | | Yes | rails params + permit! + dto |
| dry_validation | | | Yes | rails params + permit! + dto |
| rails params + expect | | | No | no DTO |
| rails params + require + permit | | | No | no DTO |

## Failed Validation
| dto | time(s) | us/op | bytes | validates types | comments |
| --- | --- | --- | --- | --- | --- |
| activemodel_plain | | | | No | rails params + permit! + dto |
| activemodel_no_enforcement | | | | No | rails params + permit! + dto |
| easytalk | | | | Yes | rails params + permit! + dto |
| easytalk_plain | | | | Yes | rails params + permit! + dto |
| dry_struct | | | | Yes | rails params + permit! + dto |
| sorbet_struct | | | | Yes | rails params + permit! + dto |
| dry_struct_plain | | | | Yes | rails params + permit! + dto |
| sorbet_struct_plain | | | | Yes | rails params + permit! + dto |
| rails params + expect | | | | No | no DTO |
| rails params + require + permit | | | | No | no DTO |
| active_record | | | | Yes | rails params + permit! + dto |
| activemodel | | | | Yes | rails params + permit! + dto |
| dry_validation | | | | Yes | rails params + permit! + dto |

## Failed MemoryProfiler
| dto | total allocated | objects | validates types | comments |
| --- | --- | --- | --- | --- |
| activemodel_plain | | | No | rails params + permit! + dto |
| activemodel_no_enforcement | | | No | rails params + permit! + dto |
| easytalk_plain | | | Yes | rails params + permit! + dto |
| easytalk | | | Yes | rails params + permit! + dto |
| dry_struct | | | Yes | rails params + permit! + dto |
| sorbet_struct | | | Yes | rails params + permit! + dto |
| rails params + require + permit | | | No | no DTO |
| rails params + expect | | | No | no DTO |
| dry_struct_plain | | | Yes | rails params + permit! + dto |
| active_record | | | Yes | rails params + permit! + dto |
| sorbet_struct_plain | | | Yes | rails params + permit! + dto |
| activemodel | | | Yes | rails params + permit! + dto |
| dry_validation | | | Yes | rails params + permit! + dto |

Notes:
- All cases use the same payload shape.
- Order rows by best performance (lowest time(s) for Validation, lowest total allocated for MemoryProfiler).
