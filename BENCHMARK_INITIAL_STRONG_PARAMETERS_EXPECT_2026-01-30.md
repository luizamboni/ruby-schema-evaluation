# Ruby Schema Evaluation - Benchmark Results (StrongParameters expect)

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: 2026-01-30
Ruby: 3.3.0 (RVM)
Rails: 8.1.2
Iterations: 10_000

## Validation (construct + validate)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0226 | 2.26 | 32 |
| dry_struct_plain | 0.0338 | 3.38 | 0 |
| activemodel_plain | 0.0488 | 4.88 | 32 |
| easytalk_plain | 0.0572 | 5.72 | 32 |
| sorbet_struct | 0.0572 | 5.72 | 16 |
| strong_parameters_permit_all | 0.0736 | 7.36 | 0 |
| dry_struct | 0.0795 | 7.95 | 16 |
| easytalk | 0.1183 | 11.83 | 16 |
| active_record | 0.1414 | 14.14 | 1696 |
| activemodel | 0.1564 | 15.64 | 16 |
| dry_validation | 0.2198 | 21.98 | 16 |
| strong_parameters | 0.2574 | 25.74 | 976 |
| strong_parameters_expect | 0.2747 | 27.47 | 56 |

## Serialization (JSON only)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| strong_parameters_expect | 0.0064 | 0.64 | 0 |
| dry_validation | 0.0098 | 0.98 | 352 |
| easytalk_plain | 0.0170 | 1.70 | 0 |
| easytalk | 0.0180 | 1.80 | 0 |
| sorbet_struct | 0.0235 | 2.35 | 0 |
| sorbet_struct_plain | 0.0242 | 2.42 | 0 |
| dry_struct_plain | 0.0338 | 3.38 | 0 |
| dry_struct | 0.0361 | 3.61 | 0 |
| strong_parameters | 0.0447 | 4.47 | 0 |
| strong_parameters_permit_all | 0.0451 | 4.51 | 0 |
| active_record | 0.0505 | 5.05 | 0 |
| activemodel_plain | 0.1019 | 10.19 | 0 |
| activemodel | 0.1361 | 13.61 | 0 |

## Create + Serialize (JSON)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0483 | 4.83 | 0 |
| dry_struct_plain | 0.0698 | 6.98 | 0 |
| easytalk_plain | 0.0772 | 7.72 | 0 |
| sorbet_struct | 0.0853 | 8.53 | 0 |
| dry_struct | 0.1183 | 11.83 | 0 |
| strong_parameters_permit_all | 0.1244 | 12.44 | 0 |
| easytalk | 0.1403 | 14.03 | 0 |
| activemodel_plain | 0.1626 | 16.26 | 0 |
| active_record | 0.2109 | 21.09 | 0 |
| dry_validation | 0.2196 | 21.96 | 680 |
| strong_parameters_expect | 0.3086 | 30.86 | 0 |
| strong_parameters | 0.3111 | 31.11 | 0 |
| activemodel | 0.3173 | 31.73 | 0 |

## MemoryProfiler (allocations)
| name | total allocated | objects |
| --- | --- | --- |
| sorbet_struct_plain | 8.80 MB | 100000 objects |
| dry_struct_plain | 9.20 MB | 110000 objects |
| sorbet_struct | 17.20 MB | 270000 objects |
| dry_struct | 18.00 MB | 240000 objects |
| easytalk_plain | 20.40 MB | 260000 objects |
| activemodel_plain | 21.60 MB | 280000 objects |
| strong_parameters_permit_all | 23.20 MB | 320000 objects |
| active_record | 26.40 MB | 360000 objects |
| easytalk | 27.20 MB | 450000 objects |
| activemodel | 34.80 MB | 580029 objects |
| dry_validation | 41.12 MB | 530000 objects |
| strong_parameters | 76.24 MB | 970000 objects |
| strong_parameters_expect | 84.24 MB | 1080000 objects |

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
- MemoryProfiler totals show total allocated memory and object counts over the run.
