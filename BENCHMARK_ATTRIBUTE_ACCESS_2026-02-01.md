# Attribute Access Benchmark

Run: `bundle exec rspec spec/benchmark_attribute_access_spec.rb`
Date: 2026-02-01
Ruby: 3.3.0
Rails: 8.1.2
Iterations: 1000000

## Attribute Access
| name | time(s) | us/op |
| --- | --- | --- |
| easytalk_plain_access | 0.0977 | 0.10 |
| sorbet_struct_access | 0.0977 | 0.10 |
| easytalk_access | 0.0980 | 0.10 |
| sorbet_struct_plain_access | 0.0981 | 0.10 |
| hash_symbol_access | 0.1173 | 0.12 |
| hash_string_access | 0.1312 | 0.13 |
| dry_struct_access | 0.1527 | 0.15 |
| dry_struct_plain_access | 0.1530 | 0.15 |
| active_record_access | 0.5676 | 0.57 |
| activemodel_no_enforcement_access | 0.9790 | 0.98 |
| activemodel_plain_access | 0.9815 | 0.98 |
| activemodel_access | 0.9908 | 0.99 |
| params_symbol_access | 1.2168 | 1.22 |
| params_string_access | 1.2608 | 1.26 |
