# Failed Benchmark Diff (fast array validation toggle)

Compared against `BENCHMARK_FAILED_DIFF_LIGHTWEIGHT_ERRORS.md` "new(s)" values (10_000 iterations).

## Failed validation time deltas
| name | prev(s) | new(s) | delta(s) |
| --- | --- | --- | --- |
| easytalk | 0.0443 | 0.0446 | +0.0003 |
| dry_struct | 0.0679 | 0.0707 | +0.0028 |
| sorbet_struct | 0.0677 | 0.0696 | +0.0019 |
| dry_struct_plain | 0.2143 | 0.2141 | -0.0002 |
| sorbet_struct_plain | 0.2157 | 0.2156 | -0.0001 |
| activemodel | 1.2899 | 1.2906 | +0.0007 |
| dry_validation | 1.3316 | 1.3149 | -0.0167 |

## MemoryProfiler (allocations)
| name | prev MB (objects) | new MB (objects) | delta |
| --- | --- | --- | --- |
| easytalk | 27.76 (180000) | 27.76 (180000) | no change |
| dry_struct | 34.16 (260002) | 34.16 (260002) | no change |
| sorbet_struct | 36.16 (340001) | 36.16 (340001) | no change |
| dry_struct_plain | 157.18 (1000000) | 157.18 (1000000) | no change |
| sorbet_struct_plain 219.26 (1170000) | 219.26 (1170000) | no change |  |
| activemodel | 354.27 (3520002) | 354.27 (3520002) | no change |
| dry_validation | 504.24 (5860000) | 504.24 (5860000) | no change |

## Quick takeaways
- Failed‑path numbers are essentially unchanged.
