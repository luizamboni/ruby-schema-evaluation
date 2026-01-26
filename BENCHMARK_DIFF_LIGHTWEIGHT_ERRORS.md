# Benchmark Diff (lightweight error accumulator)

Compared against `BENCHMARK_INITIAL.md` baseline (10_000 iterations).

## Validation (construct + validate) time deltas
```
name                   old(s)   new(s)   delta(s)
sorbet_struct_plain     0.0238   0.0242   +0.0004
dry_struct_plain        0.0348   0.0364   +0.0016
activemodel_plain       0.0498   0.0501   +0.0003
easytalk_plain          0.0587   0.0619   +0.0032
sorbet_struct           0.0765   0.0619   -0.0146
dry_struct              0.1089   0.0923   -0.0166
easytalk                0.1328   0.1331   +0.0003
activemodel             0.1604   0.1664   +0.0060
dry_validation          0.2252   0.2213   -0.0039
```

## Serialization (JSON) time deltas
```
name                   old(s)   new(s)   delta(s)
dry_validation          0.0104   0.0104    0.0000
easytalk_plain          0.0181   0.0195   +0.0014
easytalk                0.0194   0.0194    0.0000
sorbet_struct_plain     0.0251   0.0254   +0.0003
sorbet_struct           0.0252   0.0256   +0.0004
dry_struct_plain        0.0349   0.0349    0.0000
dry_struct              0.0351   0.0355   +0.0004
activemodel_plain       0.1066   0.1093   +0.0027
activemodel             0.1424   0.1446   +0.0022
```

## Create + Serialize (JSON) time deltas
```
name                   old(s)   new(s)   delta(s)
sorbet_struct_plain     0.0505   0.0517   +0.0012
dry_struct_plain        0.0726   0.0745   +0.0019
easytalk_plain          0.0818   0.0823   +0.0005
sorbet_struct           0.1057   0.1339   +0.0282
dry_struct              0.1479   0.1308   -0.0171
easytalk                0.1564   0.1914   +0.0350
activemodel_plain       0.1890   0.1748   -0.0142
dry_validation          0.2269   0.2291   +0.0022
activemodel             0.3295   0.3386   +0.0091
```

## MemoryProfiler (allocations)
```
name               old MB (objects)      new MB (objects)      delta
sorbet_struct_plain 8.80 (100000)        8.80 (100000)         no change
dry_struct_plain    9.20 (110000)        9.20 (110000)         no change
easytalk_plain     20.40 (260000)       20.40 (260000)         no change
activemodel_plain  21.60 (280000)       21.60 (280000)         no change
sorbet_struct      26.00 (400000)       18.00 (280000)         -8.00 MB, -120000 objs
dry_struct         29.60 (380000)       18.80 (260000)         -10.80 MB, -120000 objs
easytalk           36.00 (560000)       28.80 (480000)         -7.20 MB, -80000 objs
activemodel        34.80 (580000)       34.80 (580000)         no change
dry_validation     41.12 (530000)       41.12 (530000)         no change
```

## Quick takeaways
- Dry/Sorbet enhanced modules improved in validation time and allocations.
- EasyTalk validation time stayed roughly flat, but allocations dropped.
- Most serialization numbers are within noise.
