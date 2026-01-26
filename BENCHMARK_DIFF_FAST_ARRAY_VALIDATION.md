# Benchmark Diff (fast array validation toggle)

Compared against `BENCHMARK_DIFF_LIGHTWEIGHT_ERRORS.md` "new(s)" values (10_000 iterations).

## Validation (construct + validate) time deltas
```
name                   prev(s)  new(s)   delta(s)
sorbet_struct_plain     0.0242   0.0238   -0.0004
dry_struct_plain        0.0364   0.0345   -0.0019
activemodel_plain       0.0501   0.0503   +0.0002
easytalk_plain          0.0619   0.0603   -0.0016
sorbet_struct           0.0619   0.0582   -0.0037
dry_struct              0.0923   0.0820   -0.0103
easytalk                0.1331   0.1199   -0.0132
activemodel             0.1664   0.2378   +0.0714
dry_validation          0.2213   0.2263   +0.0050
```

## Serialization (JSON) time deltas
```
name                   prev(s)  new(s)   delta(s)
dry_validation          0.0104   0.0106   +0.0002
easytalk                0.0194   0.0191   -0.0003
easytalk_plain          0.0195   0.0196   +0.0001
sorbet_struct_plain     0.0254   0.0263   +0.0009
sorbet_struct           0.0256   0.0253   -0.0003
dry_struct_plain        0.0349   0.0355   +0.0006
dry_struct              0.0355   0.0365   +0.0010
activemodel_plain       0.1093   0.1071   -0.0022
activemodel             0.1446   0.1426   -0.0020
```

## Create + Serialize (JSON) time deltas
```
name                   prev(s)  new(s)   delta(s)
sorbet_struct_plain     0.0517   0.0509   -0.0008
dry_struct_plain        0.0745   0.0726   -0.0019
easytalk_plain          0.0823   0.0864   +0.0041
sorbet_struct           0.1339   0.0868   -0.0471
dry_struct              0.1308   0.1233   -0.0075
easytalk                0.1914   0.1505   -0.0409
activemodel_plain       0.1748   0.1697   -0.0051
dry_validation          0.2291   0.2309   +0.0018
activemodel             0.3386   0.3371   -0.0015
```

## MemoryProfiler (allocations)
```
name               prev MB (objects)      new MB (objects)      delta
sorbet_struct_plain 8.80 (100000)         8.80 (100000)         no change
dry_struct_plain    9.20 (110000)         9.20 (110000)         no change
easytalk_plain     20.40 (260000)        20.40 (260000)         no change
activemodel_plain  21.60 (280000)        21.60 (280000)         no change
sorbet_struct      18.00 (280000)        17.20 (270000)         -0.80 MB, -10000 objs
dry_struct         18.80 (260000)        18.00 (240000)         -0.80 MB, -20000 objs
easytalk           28.80 (480000)        27.20 (450000)         -1.60 MB, -30000 objs
activemodel        34.80 (580000)        34.80 (580000)         no change
dry_validation     41.12 (530000)        41.12 (530000)         no change
```

## Quick takeaways
- Dry/Sorbet/EasyTalk improved on happy‑path validation and create+serialize.
- Allocations dropped slightly for Dry/Sorbet/EasyTalk.
- Failed‑path results are roughly unchanged.
