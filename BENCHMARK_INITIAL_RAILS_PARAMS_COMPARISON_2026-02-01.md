# Rails Params + DTO Comparison (Permit!/to_unsafe_h/request params)

Run: `bundle exec rspec spec/benchmark_spec.rb`
Date: 2026-02-01
Ruby: 3.3.0 (RVM)
Rails: 8.1.2
Iterations: 10_000

## Validation
| dto | time(s) | us/op | bytes | validates types | comments |
| --- | --- | --- | --- | --- | --- |
| sorbet_struct_plain_request_params | 0.0440 | 4.40 | 0 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| dry_struct_plain_request_params | 0.0522 | 5.22 | 0 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| activemodel_no_enforcement_request_params | 0.0692 | 6.92 | 0 | No | request.request_parameters + deep_symbolize_keys + dto |
| activemodel_plain_request_params | 0.0696 | 6.96 | 0 | No | request.request_parameters + deep_symbolize_keys + dto |
| sorbet_struct_request_params | 0.0797 | 7.97 | 0 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| easytalk_plain_request_params | 0.0813 | 8.13 | 0 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| dry_struct_request_params | 0.1002 | 10.02 | 0 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| sorbet_struct_plain_unsafe_h | 0.1093 | 10.93 | 640 | Yes | rails params + to_unsafe_h + dto |
| dry_struct_plain_unsafe_h | 0.1217 | 12.17 | 384 | Yes | rails params + to_unsafe_h + dto |
| activemodel_no_enforcement_unsafe_h | 0.1390 | 13.90 | 384 | No | rails params + to_unsafe_h + dto |
| activemodel_plain_unsafe_h | 0.1396 | 13.96 | 384 | No | rails params + to_unsafe_h + dto |
| easytalk_request_params | 0.1399 | 13.99 | 0 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| sorbet_struct_unsafe_h | 0.1482 | 14.82 | 192 | Yes | rails params + to_unsafe_h + dto |
| easytalk_plain_unsafe_h | 0.1520 | 15.20 | 640 | Yes | rails params + to_unsafe_h + dto |
| sorbet_struct_plain | 0.1666 | 16.66 | 0 | Yes | rails params + permit! + dto |
| active_record_request_params | 0.1691 | 16.91 | 0 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| dry_struct_plain | 0.1809 | 18.09 | 0 | Yes | rails params + permit! + dto |
| dry_struct_unsafe_h | 0.1863 | 18.63 | 192 | Yes | rails params + to_unsafe_h + dto |
| activemodel_request_params | 0.1865 | 18.65 | 0 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| activemodel_plain | 0.1969 | 19.69 | 0 | No | rails params + permit! + dto |
| activemodel_no_enforcement | 0.1974 | 19.74 | 0 | No | rails params + permit! + dto |
| easytalk_plain | 0.2082 | 20.82 | 0 | Yes | rails params + permit! + dto |
| sorbet_struct | 0.2094 | 20.94 | 0 | Yes | rails params + permit! + dto |
| easytalk_unsafe_h | 0.2317 | 23.17 | 192 | Yes | rails params + to_unsafe_h + dto |
| dry_struct | 0.2331 | 23.31 | 0 | Yes | rails params + permit! + dto |
| active_record_unsafe_h | 0.2438 | 24.38 | 192 | Yes | rails params + to_unsafe_h + dto |
| activemodel_unsafe_h | 0.2648 | 26.48 | 192 | Yes | rails params + to_unsafe_h + dto |
| dry_validation_request_params | 0.2793 | 27.93 | 160 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| easytalk | 0.2828 | 28.28 | 0 | Yes | rails params + permit! + dto |
| active_record | 0.3069 | 30.69 | 1560 | Yes | rails params + permit! + dto |
| activemodel | 0.3282 | 32.82 | 0 | Yes | rails params + permit! + dto |
| dry_validation_unsafe_h | 0.3582 | 35.82 | 2016 | Yes | rails params + to_unsafe_h + dto |
| dry_validation | 0.4448 | 44.48 | 160 | Yes | rails params + permit! + dto |
| rails params + require + permit | 0.5735 | 57.35 | -360 | No | no DTO |
| rails params + expect | 0.6734 | 67.34 | 40 | No | no DTO |

## MemoryProfiler
| dto | total allocated | objects | validates types | comments |
| --- | --- | --- | --- | --- |
| sorbet_struct_plain_request_params | 12.40 MB | 130000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| dry_struct_plain_request_params | 12.80 MB | 140000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| sorbet_struct_request_params | 16.00 MB | 270000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| dry_struct_request_params | 18.40 MB | 250000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| easytalk_plain_request_params | 24.00 MB | 290000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| activemodel_plain_request_params | 25.20 MB | 310000 | No | request.request_parameters + deep_symbolize_keys + dto |
| activemodel_no_enforcement_request_params | 25.20 MB | 310000 | No | request.request_parameters + deep_symbolize_keys + dto |
| easytalk_request_params | 26.00 MB | 450000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| sorbet_struct_plain_unsafe_h | 26.80 MB | 270000 | Yes | rails params + to_unsafe_h + dto |
| active_record_request_params | 26.80 MB | 370000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| dry_struct_plain_unsafe_h | 27.20 MB | 280000 | Yes | rails params + to_unsafe_h + dto |
| sorbet_struct_unsafe_h | 30.40 MB | 410000 | Yes | rails params + to_unsafe_h + dto |
| dry_struct_unsafe_h | 32.80 MB | 390000 | Yes | rails params + to_unsafe_h + dto |
| activemodel_request_params | 33.60 MB | 580000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| sorbet_struct_plain | 36.80 MB | 450000 | Yes | rails params + permit! + dto |
| dry_struct_plain | 37.20 MB | 460000 | Yes | rails params + permit! + dto |
| easytalk_plain_unsafe_h | 38.40 MB | 430000 | Yes | rails params + to_unsafe_h + dto |
| activemodel_plain_unsafe_h | 39.60 MB | 450000 | Yes | rails params + to_unsafe_h + dto |
| activemodel_no_enforcement_unsafe_h | 39.60 MB | 450000 | Yes | rails params + to_unsafe_h + dto |
| easytalk_unsafe_h | 40.40 MB | 590000 | Yes | rails params + to_unsafe_h + dto |
| sorbet_struct | 40.40 MB | 590000 | Yes | rails params + permit! + dto |
| active_record_unsafe_h | 41.20 MB | 510000 | Yes | rails params + to_unsafe_h + dto |
| dry_validation_request_params | 41.52 MB | 540000 | Yes | request.request_parameters + deep_symbolize_keys + dto |
| dry_struct | 42.80 MB | 570000 | Yes | rails params + permit! + dto |
| activemodel_unsafe_h | 48.00 MB | 720000 | Yes | rails params + to_unsafe_h + dto |
| easytalk_plain | 48.40 MB | 610000 | Yes | rails params + permit! + dto |
| activemodel_plain | 49.60 MB | 630000 | No | rails params + permit! + dto |
| activemodel_no_enforcement | 49.60 MB | 630000 | No | rails params + permit! + dto |
| easytalk | 50.40 MB | 770000 | Yes | rails params + permit! + dto |
| active_record | 51.20 MB | 690000 | Yes | rails params + permit! + dto |
| dry_validation_unsafe_h | 55.92 MB | 680000 | Yes | rails params + to_unsafe_h + dto |
| activemodel | 58.00 MB | 900000 | Yes | rails params + permit! + dto |
| dry_validation | 65.92 MB | 860000 | Yes | rails params + permit! + dto |
| rails params + expect | 80.24 MB | 1040000 | No | no DTO |
| rails params + require + permit | 85.04 MB | 1060000 | No | no DTO |

## Failed Validation
Not run in this report.

## Failed MemoryProfiler
Not run in this report.

Notes:
- All cases use the same payload shape.
- Order rows by best performance (lowest time(s) for Validation, lowest total allocated for MemoryProfiler).
