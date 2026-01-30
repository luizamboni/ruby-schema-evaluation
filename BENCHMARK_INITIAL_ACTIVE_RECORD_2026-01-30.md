# Ruby Schema Evaluation - Benchmark Results (ActiveRecord)

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: 2026-01-30
Ruby: 3.3.0 (RVM)
Iterations: 10_000

## Validation (construct + validate)
```
name                              time(s)        us/op        bytes
sorbet_struct_plain                0.0232         2.32           32
dry_struct_plain                   0.0341         3.41            0
activemodel_plain                  0.0549         5.49           32
sorbet_struct                      0.0579         5.79           16
easytalk_plain                     0.0585         5.85           32
strong_parameters_permit_all       0.0743         7.43            0
dry_struct                         0.0796         7.96           16
easytalk                           0.1170        11.70           16
active_record                      0.1501        15.01         1736
activemodel                        0.1608        16.08           16
dry_validation                     0.2170        21.70           16
strong_parameters                  0.2659        26.59         1088
```

## Serialization (JSON only)
```
name                              time(s)        us/op        bytes
dry_validation                     0.0180         1.80          224
easytalk                           0.0272         2.72            0
sorbet_struct_plain                0.0334         3.34            0
sorbet_struct                      0.0343         3.43            0
dry_struct                         0.0433         4.33         -160
dry_struct_plain                   0.0437         4.37            0
strong_parameters                  0.0546         5.46            0
strong_parameters_permit_all       0.0555         5.55            0
active_record                      0.0601         6.01            0
easytalk_plain                     0.0614         6.14            0
activemodel_plain                  0.1159        11.59          224
activemodel                        0.1466        14.66            0
```

## Create + Serialize (JSON)
```
name                              time(s)        us/op        bytes
sorbet_struct_plain                0.0621         6.21          224
dry_struct_plain                   0.0817         8.17            0
easytalk_plain                     0.0926         9.26          224
sorbet_struct                      0.1002        10.02          224
dry_struct                         0.1343        13.43          224
strong_parameters_permit_all       0.1348        13.48            0
easytalk                           0.1566        15.66          224
activemodel_plain                  0.1854        18.54            0
active_record                      0.2306        23.06          224
dry_validation                     0.2439        24.39          384
activemodel                        0.3272        32.72          224
strong_parameters                  0.3292        32.92          224
```

## MemoryProfiler (allocations)
```
sorbet_struct_plain                8.80 MB (100000 objects)
dry_struct_plain                   9.20 MB (110000 objects)
sorbet_struct                     17.20 MB (270000 objects)
dry_struct                        18.00 MB (240000 objects)
easytalk_plain                    20.40 MB (260000 objects)
activemodel_plain                 21.60 MB (280000 objects)
strong_parameters_permit_all      23.20 MB (320000 objects)
active_record                     26.80 MB (360000 objects)
easytalk                          27.20 MB (450000 objects)
activemodel                       34.00 MB (560000 objects)
dry_validation                    41.12 MB (530000 objects)
strong_parameters                 79.44 MB (1020000 objects)
```

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
- MemoryProfiler totals show total allocated memory and object counts over the run.
