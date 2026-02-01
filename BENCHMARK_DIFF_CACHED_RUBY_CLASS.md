# Benchmark Diff (cached ruby_class in schema cache)

Compared against `BENCHMARK_DIFF_LAZY_ERRORS.md` "new(s)" values (10_000 iterations).

## Validation (construct + validate) time deltas
| name | prev(s) | new(s) | delta(s) |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0240 | 0.0242 | +0.0002 |
| dry_struct_plain | 0.0348 | 0.0349 | +0.0001 |
| activemodel_plain | 0.0504 | 0.0500 | -0.0004 |
| easytalk_plain | 0.0606 | 0.0597 | -0.0009 |
| sorbet_struct | 0.0609 | 0.0630 | +0.0021 |
| dry_struct | 0.0861 | 0.0854 | -0.0007 |
| easytalk | 0.1302 | 0.1282 | -0.0020 |
| activemodel | 0.1625 | 0.1646 | +0.0021 |
| dry_validation | 0.2198 | 0.2199 | +0.0001 |

## Serialization (JSON) time deltas
| name | prev(s) | new(s) | delta(s) |
| --- | --- | --- | --- |
| dry_validation | 0.0107 | 0.0107 | 0.0000 |
| easytalk_plain | 0.0190 | 0.0188 | -0.0002 |
| easytalk | 0.0193 | 0.0186 | -0.0007 |
| sorbet_struct_plain | 0.0256 | 0.0249 | -0.0007 |
| sorbet_struct | 0.0263 | 0.0249 | -0.0014 |
| dry_struct_plain | 0.0364 | 0.0345 | -0.0019 |
| dry_struct | 0.0366 | 0.0348 | -0.0018 |
| activemodel_plain | 0.1053 | 0.1035 | -0.0018 |
| activemodel | 0.1409 | 0.1405 | -0.0004 |

## Create + Serialize (JSON) time deltas
| name | prev(s) | new(s) | delta(s) |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0511 | 0.0517 | +0.0006 |
| dry_struct_plain | 0.0721 | 0.0719 | -0.0002 |
| easytalk_plain | 0.0949 | 0.0820 | -0.0129 |
| sorbet_struct | 0.0886 | 0.0887 | +0.0001 |
| dry_struct | 0.1251 | 0.1256 | +0.0005 |
| easytalk | 0.1511 | 0.1494 | -0.0017 |
| activemodel_plain | 0.1677 | 0.1687 | +0.0010 |
| dry_validation | 0.2284 | 0.2250 | -0.0034 |
| activemodel | 0.3282 | 0.3273 | -0.0009 |

## MemoryProfiler (allocations)
| name | prev MB (objects) | new MB (objects) | delta |
| --- | --- | --- | --- |
| sorbet_struct_plain 8.80 (100000) | 8.80 (100000) | no change |  |
| dry_struct_plain | 9.20 (110000) | 9.20 (110000) | no change |
| sorbet_struct | 18.00 (280000) | 18.00 (280000) | no change |
| dry_struct | 18.80 (260000) | 18.80 (260000) | no change |
| easytalk_plain | 20.40 (260000) | 20.40 (260000) | no change |
| activemodel_plain | 21.60 (280000) | 21.60 (280000) | no change |
| easytalk | 28.80 (480000) | 28.80 (480000) | no change |
| activemodel | 34.80 (580000) | 34.80 (580000) | no change |
| dry_validation | 41.12 (530000) | 41.12 (530000) | no change |

## Quick takeaways
- EasyTalk paths improved slightly in validation/serialization; changes are small but consistent.
- Most other results are within noise.
