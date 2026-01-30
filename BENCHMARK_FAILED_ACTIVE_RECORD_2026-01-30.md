# Failed Validation Benchmark (ActiveRecord)

Run: `bundle exec rspec spec/benchmark_failed_spec.rb`
Date: 2026-01-30
Ruby: 3.3.0 (RVM)
Iterations: 10_000

## Failed validation (invalid payload)
```
name                              time(s)        us/op        bytes                error
activemodel_plain                       -            -            -                    -
easytalk                           0.0428         4.28         2216      ValidationError
easytalk_plain                          -            -            -                    -
sorbet_struct                      0.0614         6.14         2296      ValidationError
dry_struct                         0.0653         6.53            0      ValidationError
strong_parameters_permit_all            -            -            -                    -
dry_struct_plain                   0.2050        20.50            0   Dry::Struct::Error
sorbet_struct_plain                0.2080        20.80        13207            TypeError
strong_parameters                       -            -            -                    -
active_record                      0.8156        81.56            0 ActiveRecord::RecordInvalid
activemodel                        1.2899       128.99         4296 ActiveModel::ValidationError
dry_validation                     1.3441       134.41            0                    -
```

## MemoryProfiler (allocations)
```
name                    total allocated
easytalk                 27.36 MB (180009 objects)
dry_struct               34.16 MB (260002 objects)
sorbet_struct            36.16 MB (340001 objects)
dry_struct_plain         157.18 MB (1000000 objects)
active_record            198.88 MB (1980000 objects)
sorbet_struct_plain      219.26 MB (1170000 objects)
activemodel              353.47 MB (3500002 objects)
dry_validation           504.24 MB (5860000 objects)
easytalk_plain           -
activemodel_plain        -
strong_parameters        -
strong_parameters_permit_all -
```

Notes:
- `bytes` is the ObjectSpace delta during the loop; it can be noisy or negative.
