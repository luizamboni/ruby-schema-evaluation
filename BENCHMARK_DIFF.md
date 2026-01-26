# Benchmark Diff (after schema cache memoization)

Compared against `BENCHMARK_INITIAL.md` baseline (10_000 iterations).

## Validation (construct + validate) time deltas
```
name                   old(s)   new(s)   delta(s)
sorbet_struct_plain     0.0238   0.0233   -0.0005
dry_struct_plain        0.0348   0.0350   +0.0002
activemodel_plain       0.0498   0.0493   -0.0005
easytalk_plain          0.0587   0.0594   +0.0007
sorbet_struct           0.0765   0.0676   -0.0089
dry_struct              0.1089   0.1039   -0.0050
easytalk                0.1328   0.1431   +0.0103
activemodel             0.1604   0.1629   +0.0025
dry_validation          0.2252   0.2209   -0.0043
```

## Serialization (JSON) time deltas
```
name                   old(s)   new(s)   delta(s)
dry_validation          0.0104   0.0102   -0.0002
easytalk_plain          0.0181   0.0181    0.0000
easytalk                0.0194   0.0194    0.0000
sorbet_struct_plain     0.0251   0.0249   -0.0002
sorbet_struct           0.0252   0.0251   -0.0001
dry_struct_plain        0.0349   0.0349    0.0000
dry_struct              0.0351   0.0349   -0.0002
activemodel_plain       0.1066   0.1049   -0.0017
activemodel             0.1424   0.1433   +0.0009
```

## Create + Serialize (JSON) time deltas
```
name                   old(s)   new(s)   delta(s)
sorbet_struct_plain     0.0505   0.0503   -0.0002
dry_struct_plain        0.0726   0.0718   -0.0008
easytalk_plain          0.0818   0.0849   +0.0031
sorbet_struct           0.1057   0.0949   -0.0108
dry_struct              0.1479   0.1424   -0.0055
easytalk                0.1564   0.1669   +0.0105
activemodel_plain       0.1890   0.1689   -0.0201
dry_validation          0.2269   0.2279   +0.0010
activemodel             0.3295   0.3288   -0.0007
```

## MemoryProfiler (allocations)
```
name               old MB (objects)      new MB (objects)      delta
sorbet_struct_plain 8.80 (100000)        8.80 (100000)         no change
dry_struct_plain    9.20 (110000)        9.20 (110000)         no change
easytalk_plain     20.40 (260000)       20.40 (260000)         no change
activemodel_plain  21.60 (280000)       21.60 (280000)         no change
sorbet_struct      26.00 (400000)       21.20 (280000)         -4.80 MB, -120000 objs
dry_struct         29.60 (380000)       27.60 (330000)         -2.00 MB,  -50000 objs
activemodel        34.80 (580000)       34.80 (580000)         no change
easytalk           36.00 (560000)       36.00 (560000)         no change
dry_validation     41.12 (530000)       41.12 (530000)         no change
```

## Quick takeaways
- Dry/Sorbet enhanced modules improved (lower validation time and fewer allocations).
- EasyTalk got slightly slower in validation/create+serialize, but allocations returned to baseline.
- Most “plain” variants stayed essentially flat, as expected.
