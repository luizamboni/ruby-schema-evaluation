# Ruby Schema Evaluation - Benchmark Results (StrongParameters permit!)

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: 2026-01-30
Ruby: 3.3.0 (RVM)
Iterations: 10_000

## Validation (construct + validate)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0234 | 2.34 | 32 |
| dry_struct_plain | 0.0349 | 3.49 | 0 |
| activemodel_plain | 0.0548 | 5.48 | 32 |
| sorbet_struct | 0.0567 | 5.67 | 16 |
| easytalk_plain | 0.0599 | 5.99 | 32 |
| strong_parameters_permit_all | 0.0794 | 7.94 | 960 |
| dry_struct | 0.0813 | 8.13 | 16 |
| easytalk | 0.1172 | 11.72 | -584 |
| activemodel | 0.1670 | 16.70 | 16 |
| dry_validation | 0.2162 | 21.62 | 16 |
| strong_parameters | 0.2723 | 27.23 | 128 |

## Serialization (JSON only)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| dry_validation | 0.0169 | 1.69 | 384 |
| easytalk_plain | 0.0271 | 2.71 | 0 |
| easytalk | 0.0281 | 2.81 | 0 |
| sorbet_struct | 0.0327 | 3.27 | 224 |
| sorbet_struct_plain | 0.0333 | 3.33 | 224 |
| dry_struct_plain | 0.0433 | 4.33 | 0 |
| dry_struct | 0.0438 | 4.38 | 0 |
| strong_parameters | 0.0542 | 5.42 | 224 |
| Iactivemodel_plain | 0.1124 | 11.24 | 224 |
| activemodel | 0.1382 | 13.82 | 0 |

## Create + Serialize (JSON)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0596 | 5.96 | 224 |
| dry_struct_plain | 0.0821 | 8.21 | 224 |
| easytalk_plain | 0.0894 | 8.94 | 0 |
| sorbet_struct | 0.0991 | 9.91 | 0 |
| dry_struct | 0.1284 | 12.84 | 224 |
| strong_parameters_permit_all | 0.1340 | 13.40 | 0 |
| easytalk | 0.1502 | 15.02 | 224 |
| activemodel_plain | 0.1789 | 17.89 | 224 |
| dry_validation | 0.2401 | 24.01 | 224 |
| activemodel | 0.3288 | 32.88 | 224 |
| strong_parameters | 0.3339 | 33.39 | 224 |

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
| easytalk | 27.20 MB | 450000 objects |
| activemodel | 34.00 MB | 560000 objects |
| dry_validation | 41.12 MB | 530000 objects |
| strong_parameters | 79.44 MB | 1020000 objects |

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
- MemoryProfiler totals show total allocated memory and object counts over the run.
