# Failed Benchmark Diff (lightweight error accumulator)

Compared against `BENCHMARK_FAILED.md` baseline (10_000 iterations).

## Failed validation time deltas
| name | old(s) | new(s) | delta(s) |
| --- | --- | --- | --- |
| easytalk | 0.0395 | 0.0443 | +0.0048 |
| sorbet_struct | 0.0590 | 0.0677 | +0.0087 |
| dry_struct | 0.0615 | 0.0679 | +0.0064 |
| dry_struct_plain | 0.2128 | 0.2143 | +0.0015 |
| sorbet_struct_plain | 0.2182 | 0.2157 | -0.0025 |
| activemodel | 1.2565 | 1.2899 | +0.0334 |
| dry_validation | 1.3785 | 1.3316 | -0.0469 |

## MemoryProfiler (allocations)
| name | old MB (objects) | new MB (objects) | delta |
| --- | --- | --- | --- |
| easytalk | 24.96 (160000) | 27.76 (180000) | +2.80 MB, +20000 objs |
| dry_struct | 33.36 (260002) | 34.16 (260002) | +0.80 MB |
| sorbet_struct | 33.76 (320001) | 36.16 (340001) | +2.40 MB, +20000 objs |
| dry_struct_plain | 157.18 (1000000) | 157.18 (1000000) | no change |
| sorbet_struct_plain | 219.26 (1170000) | 219.26 (1170000) | no change |
| activemodel | 354.27 (3520002) | 354.27 (3520002) | no change |
| dry_validation | 504.24 (5860000) | 504.24 (5860000) | no change |

## Quick takeaways
- Failed‑path timings got slightly worse for most enhanced modules.
- Allocations increased for EasyTalk/Sorbet on failure; others are flat.
