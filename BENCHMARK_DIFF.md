# Benchmark Diff (after schema cache change)

Compared against `README.md` baseline (10_000 iterations).

## Validation (construct + validate) time deltas
```
name                   old(s)   new(s)   delta(s)
sorbet_struct_plain     0.0238   0.0237   -0.0001
dry_struct_plain        0.0348   0.0348    0.0000
activemodel_plain       0.0498   0.0492   -0.0006
easytalk_plain          0.0587   0.0591   +0.0004
sorbet_struct           0.0765   0.0664   -0.0101
dry_struct              0.1089   0.1018   -0.0071
easytalk                0.1328   0.1602   +0.0274
activemodel             0.1604   0.1619   +0.0015
dry_validation          0.2252   0.2239   -0.0013
```

## Serialization (JSON) time deltas
```
name                   old(s)   new(s)   delta(s)
dry_validation          0.0104   0.0103   -0.0001
easytalk_plain          0.0181   0.0203   +0.0022
easytalk                0.0194   0.0212   +0.0018
sorbet_struct_plain     0.0251   0.0271   +0.0020
sorbet_struct           0.0252   0.0265   +0.0013
dry_struct_plain        0.0349   0.0343   -0.0006
dry_struct              0.0351   0.0348   -0.0003
activemodel_plain       0.1066   0.1068   +0.0002
activemodel             0.1424   0.1457   +0.0033
```

## Create + Serialize (JSON) time deltas
```
name                   old(s)   new(s)   delta(s)
sorbet_struct_plain     0.0505   0.0500   -0.0005
dry_struct_plain        0.0726   0.0729   +0.0003
easytalk_plain          0.0818   0.0826   +0.0008
sorbet_struct           0.1057   0.0966   -0.0091
dry_struct              0.1479   0.1431   -0.0048
easytalk                0.1564   0.1858   +0.0294
activemodel_plain       0.1890   0.1674   -0.0216
dry_validation          0.2269   0.2287   +0.0018
activemodel             0.3295   0.3285   -0.0010
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
easytalk           36.00 (560000)       50.00 (670000)         +14.00 MB, +110000 objs
dry_validation     41.12 (530000)       41.12 (530000)         no change
```

## Quick takeaways
- Dry/Sorbet enhanced modules improved (lower validation time and fewer allocations).
- EasyTalk got slower and allocated more; likely due to cache path in `SchemaEnforcer` for model instances.
- Most “plain” variants stayed essentially flat, as expected.
