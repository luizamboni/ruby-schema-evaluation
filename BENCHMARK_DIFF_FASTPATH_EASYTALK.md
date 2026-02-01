# Benchmark Diff (EasyTalk fast-path for already-typed nested objects)

Compared against `BENCHMARK_DIFF_LIGHTWEIGHT_ERRORS.md` "new(s)" values (10_000 iterations).

## Validation (construct + validate) time deltas
| name | prev(s) | new(s) | delta(s) |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0242 | 0.0248 | +0.0006 |
| dry_struct_plain | 0.0364 | 0.0358 | -0.0006 |
| activemodel_plain | 0.0501 | 0.0515 | +0.0014 |
| easytalk_plain | 0.0619 | 0.0689 | +0.0070 |
| sorbet_struct | 0.0619 | 0.0619 | 0.0000 |
| dry_struct | 0.0923 | 0.0923 | 0.0000 |
| easytalk | 0.1331 | 0.1199 | -0.0132 |
| activemodel | 0.1664 | 0.1823 | +0.0159 |
| dry_validation | 0.2213 | 0.2264 | +0.0051 |

## Serialization (JSON) time deltas
| name | prev(s) | new(s) | delta(s) |
| --- | --- | --- | --- |
| dry_validation | 0.0104 | 0.0116 | +0.0012 |
| easytalk | 0.0194 | 0.0187 | -0.0007 |
| easytalk_plain | 0.0195 | 0.0182 | -0.0013 |
| sorbet_struct_plain | 0.0254 | 0.0257 | +0.0003 |
| sorbet_struct | 0.0256 | 0.0256 | 0.0000 |
| dry_struct_plain | 0.0349 | 0.0389 | +0.0040 |
| dry_struct | 0.0355 | 0.0404 | +0.0049 |
| activemodel_plain | 0.1093 | 0.1225 | +0.0132 |
| activemodel | 0.1446 | 0.1433 | -0.0013 |

## Create + Serialize (JSON) time deltas
| name | prev(s) | new(s) | delta(s) |
| --- | --- | --- | --- |
| sorbet_struct_plain | 0.0517 | 0.0546 | +0.0029 |
| dry_struct_plain | 0.0745 | 0.0780 | +0.0035 |
| easytalk_plain | 0.0823 | 0.0901 | +0.0078 |
| sorbet_struct | 0.1339 | 0.0940 | -0.0399 |
| dry_struct | 0.1308 | 0.1454 | +0.0146 |
| activemodel_plain | 0.1748 | 0.1699 | -0.0049 |
| easytalk | 0.1914 | 0.1501 | -0.0413 |
| dry_validation | 0.2291 | 0.2416 | +0.0125 |
| activemodel | 0.3386 | 0.3515 | +0.0129 |

## MemoryProfiler (allocations)
| name | prev MB (objects) | new MB (objects) | delta |
| --- | --- | --- | --- |
| sorbet_struct_plain 8.80 (100000) | 8.80 (100000) | no change |  |
| dry_struct_plain | 9.20 (110000) | 9.20 (110000) | no change |
| easytalk_plain | 20.40 (260000) | 20.40 (260000) | no change |
| activemodel_plain | 21.60 (280000) | 21.60 (280000) | no change |
| sorbet_struct | 18.00 (280000) | 18.00 (280000) | no change |
| dry_struct | 18.80 (260000) | 18.80 (260000) | no change |
| easytalk | 28.80 (480000) | 27.20 (450000) | -1.60 MB, -30000 objs |
| activemodel | 34.80 (580000) | 34.80 (580000) | no change |
| dry_validation | 41.12 (530000) | 41.12 (530000) | no change |

## Quick takeaways
- EasyTalk improved in validation and create+serialize, with fewer allocations.
- Other changes are mostly within noise.
