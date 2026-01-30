# Ruby Schema Evaluation - Benchmark Results (StrongParameters)

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: 2026-01-30
Ruby: 3.3.0 (RVM)
Iterations: 10_000

## Validation (construct + validate)
```
name                    time(s)        us/op        bytes
sorbet_struct_plain      0.0249         2.49           32
dry_struct_plain         0.0364         3.64            0
activemodel_plain        0.0588         5.88           32
sorbet_struct            0.0615         6.15           16
easytalk_plain           0.0630         6.30           32
dry_struct               0.0863         8.63           16
easytalk                 0.1496        14.96         -584
activemodel              0.1807        18.07           16
dry_validation           0.2415        24.15           16
strong_parameters        0.2931        29.31          128
```

## Serialization (JSON only)
```
name                    time(s)        us/op        bytes
dry_validation           0.0193         1.93          384
easytalk_plain           0.0289         2.89            0
easytalk                 0.0295         2.95            0
sorbet_struct_plain      0.0354         3.54          224
sorbet_struct            0.0370         3.70          224
dry_struct_plain         0.0455         4.55            0
dry_struct               0.0457         4.57            0
strong_parameters        0.0548         5.48          224
activemodel_plain        0.1154        11.54          224
activemodel              0.1539        15.39          224
```

## Create + Serialize (JSON)
```
name                    time(s)        us/op        bytes
sorbet_struct_plain      0.0593         5.93          224
dry_struct_plain         0.0822         8.22          224
easytalk_plain           0.0896         8.96            0
sorbet_struct            0.0960         9.60            0
dry_struct               0.1314        13.14          224
easytalk                 0.1493        14.93          224
activemodel_plain        0.1846        18.46          224
dry_validation           0.2329        23.29          224
activemodel              0.3195        31.95          224
strong_parameters        0.3342        33.42          224
```

## MemoryProfiler (allocations)
```
sorbet_struct_plain   8.80 MB (100000 objects)
dry_struct_plain      9.20 MB (110000 objects)
sorbet_struct        17.20 MB (270000 objects)
dry_struct           18.00 MB (240000 objects)
easytalk_plain       20.40 MB (260000 objects)
activemodel_plain    21.60 MB (280000 objects)
easytalk             27.20 MB (450000 objects)
activemodel          34.00 MB (560000 objects)
dry_validation       41.12 MB (530000 objects)
strong_parameters    79.44 MB (1020000 objects)
```

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
- MemoryProfiler totals show total allocated memory and object counts over the run.
