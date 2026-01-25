# Benchmark Diff (lazy ValidationError creation)

Compared against `BENCHMARK_DIFF.md` "new(s)" values (10_000 iterations).

## Validation (construct + validate) time deltas
```
name                   prev(s)  new(s)   delta(s)
sorbet_struct_plain     0.0233   0.0240   +0.0007
dry_struct_plain        0.0350   0.0348   -0.0002
activemodel_plain       0.0493   0.0504   +0.0011
easytalk_plain          0.0594   0.0606   +0.0012
sorbet_struct           0.0676   0.0609   -0.0067
dry_struct              0.1039   0.0861   -0.0178
easytalk                0.1431   0.1302   -0.0129
activemodel             0.1629   0.1625   -0.0004
dry_validation          0.2209   0.2198   -0.0011
```

## Serialization (JSON) time deltas
```
name                   prev(s)  new(s)   delta(s)
dry_validation          0.0102   0.0107   +0.0005
easytalk_plain          0.0181   0.0190   +0.0009
easytalk                0.0194   0.0193   -0.0001
sorbet_struct_plain     0.0249   0.0256   +0.0007
sorbet_struct           0.0251   0.0263   +0.0012
dry_struct_plain        0.0349   0.0364   +0.0015
dry_struct              0.0349   0.0366   +0.0017
activemodel_plain       0.1049   0.1053   +0.0004
activemodel             0.1433   0.1409   -0.0024
```

## Create + Serialize (JSON) time deltas
```
name                   prev(s)  new(s)   delta(s)
sorbet_struct_plain     0.0503   0.0511   +0.0008
dry_struct_plain        0.0718   0.0721   +0.0003
easytalk_plain          0.0849   0.0949   +0.0100
sorbet_struct           0.0949   0.0886   -0.0063
dry_struct              0.1424   0.1251   -0.0173
easytalk                0.1669   0.1511   -0.0158
activemodel_plain       0.1689   0.1677   -0.0012
dry_validation          0.2279   0.2284   +0.0005
activemodel             0.3288   0.3282   -0.0006
```

## MemoryProfiler (allocations)
```
name               prev MB (objects)      new MB (objects)      delta
sorbet_struct_plain 8.80 (100000)         8.80 (100000)         no change
dry_struct_plain    9.20 (110000)         9.20 (110000)         no change
easytalk_plain     20.40 (260000)        20.40 (260000)         no change
activemodel_plain  21.60 (280000)        21.60 (280000)         no change
sorbet_struct      21.20 (280000)        18.00 (280000)         -3.20 MB
dry_struct         27.60 (330000)        18.80 (260000)         -8.80 MB, -70000 objs
easytalk           36.00 (560000)        28.80 (480000)         -7.20 MB, -80000 objs
activemodel        34.80 (580000)        34.80 (580000)         no change
dry_validation     41.12 (530000)        41.12 (530000)         no change
```

## Quick takeaways
- Lazy error creation reduces allocations for enhanced Dry/Sorbet/EasyTalk paths.
- Validation time improved for Dry/Sorbet/EasyTalk enhanced paths; serialization timings mostly flat/noisy.
