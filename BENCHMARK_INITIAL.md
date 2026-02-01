# Ruby Schema Evaluation - Benchmark Results

Run: `bundle exec rspec spec/benchmark_spec.rb`
Iterations: 10_000

## Validation (construct + validate)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0238 | 2.38 | 32 |
| dry_struct_plain | 0.0348 | 3.48 | 0 |
| activemodel_plain | 0.0498 | 4.98 | 32 |
| easytalk_plain | 0.0587 | 5.87 | 32 |
| sorbet_struct | 0.0765 | 7.65 | 256 |
| dry_struct | 0.1089 | 10.89 | 16 |
| easytalk | 0.1328 | 13.28 | -1304 |
| activemodel | 0.1604 | 16.04 | 16 |
| dry_validation | 0.2252 | 22.52 | 16 |

## Serialization (JSON only)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| dry_validation | 0.0104 | 1.04 | 160 |
| easytalk_plain | 0.0181 | 1.81 | 0 |
| easytalk | 0.0194 | 1.94 | 0 |
| sorbet_struct_plain | 0.0251 | 2.51 | 0 |
| sorbet_struct | 0.0252 | 2.52 | 0 |
| dry_struct_plain | 0.0349 | 3.49 | 0 |
| dry_struct | 0.0351 | 3.51 | 0 |
| activemodel_plain | 0.1066 | 10.66 | 0 |
| activemodel | 0.1424 | 14.24 | 0 |

## Create + Serialize (JSON)
| name | time(s) | us/op | bytes |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0505 | 5.05 | 0 |
| dry_struct_plain | 0.0726 | 7.26 | 0 |
| easytalk_plain | 0.0818 | 8.18 | 0 |
| sorbet_struct | 0.1057 | 10.57 | 0 |
| dry_struct | 0.1479 | 14.79 | 0 |
| easytalk | 0.1564 | 15.64 | 0 |
| activemodel_plain | 0.1890 | 18.90 | 0 |
| dry_validation | 0.2269 | 22.69 | 0 |
| activemodel | 0.3295 | 32.95 | 0 |

## MemoryProfiler (allocations)
| name | total allocated | objects |
| --- | --- | --- |
| sorbet_struct_plain | 8.80 MB | 100000 objects |
| dry_struct_plain | 9.20 MB | 110000 objects |
| easytalk_plain | 20.40 MB | 260000 objects |
| activemodel_plain | 21.60 MB | 280000 objects |
| sorbet_struct | 26.00 MB | 400000 objects |
| dry_struct | 29.60 MB | 380000 objects |
| activemodel | 34.80 MB | 580000 objects |
| easytalk | 36.00 MB | 560000 objects |
| dry_validation | 41.12 MB | 530000 objects |

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
- MemoryProfiler totals show total allocated memory and object counts over the run.
