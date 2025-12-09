This chart deploys OpenTelemetry collector.

ClickHouse schemas:

```
clickhouse-0.clickhouse-headless.o11y-clickhouse.svc.cluster.local :) SHOW TABLES;

SHOW TABLES

Query id: b8751076-b258-4e47-9347-a7f20823cc9e

   ┌─name───────────────────────────────┐
1. │ otel_logs                          │
2. │ otel_metrics_exponential_histogram │
3. │ otel_metrics_gauge                 │
4. │ otel_metrics_histogram             │
5. │ otel_metrics_sum                   │
6. │ otel_metrics_summary               │
7. │ otel_traces                        │
8. │ otel_traces_trace_id_ts            │
9. │ otel_traces_trace_id_ts_mv         │
   └────────────────────────────────────┘

9 rows in set. Elapsed: 0.011 sec.

clickhouse-0.clickhouse-headless.o11y-clickhouse.svc.cluster.local :) SHOW CREATE TABLE otel_logs;

SHOW CREATE TABLE otel_logs

Query id: c8ee71f7-2f8c-4d5b-9892-93c528f6dde1

   ┌─statement─────────────────────────────────────────────────────────────────────────────────────────┐
1. │ CREATE TABLE clickhouse.otel_logs                                                                ↴│
   │↳(                                                                                                ↴│
   │↳    `Timestamp` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                          ↴│
   │↳    `TimestampTime` DateTime DEFAULT toDateTime(Timestamp),                                      ↴│
   │↳    `TraceId` String CODEC(ZSTD(1)),                                                             ↴│
   │↳    `SpanId` String CODEC(ZSTD(1)),                                                              ↴│
   │↳    `TraceFlags` UInt8,                                                                          ↴│
   │↳    `SeverityText` LowCardinality(String) CODEC(ZSTD(1)),                                        ↴│
   │↳    `SeverityNumber` UInt8,                                                                      ↴│
   │↳    `ServiceName` LowCardinality(String) CODEC(ZSTD(1)),                                         ↴│
   │↳    `Body` String CODEC(ZSTD(1)),                                                                ↴│
   │↳    `ResourceSchemaUrl` LowCardinality(String) CODEC(ZSTD(1)),                                   ↴│
   │↳    `ResourceAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                     ↴│
   │↳    `ScopeSchemaUrl` LowCardinality(String) CODEC(ZSTD(1)),                                      ↴│
   │↳    `ScopeName` String CODEC(ZSTD(1)),                                                           ↴│
   │↳    `ScopeVersion` LowCardinality(String) CODEC(ZSTD(1)),                                        ↴│
   │↳    `ScopeAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                        ↴│
   │↳    `LogAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                          ↴│
   │↳    INDEX idx_trace_id TraceId TYPE bloom_filter(0.001) GRANULARITY 1,                           ↴│
   │↳    INDEX idx_res_attr_key mapKeys(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,    ↴│
   │↳    INDEX idx_res_attr_value mapValues(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,↴│
   │↳    INDEX idx_scope_attr_key mapKeys(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,     ↴│
   │↳    INDEX idx_scope_attr_value mapValues(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1, ↴│
   │↳    INDEX idx_log_attr_key mapKeys(LogAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,         ↴│
   │↳    INDEX idx_log_attr_value mapValues(LogAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,     ↴│
   │↳    INDEX idx_body Body TYPE tokenbf_v1(32768, 3, 0) GRANULARITY 8                               ↴│
   │↳)                                                                                                ↴│
   │↳ENGINE = MergeTree                                                                               ↴│
   │↳PARTITION BY toDate(TimestampTime)                                                               ↴│
   │↳PRIMARY KEY (ServiceName, TimestampTime)                                                         ↴│
   │↳ORDER BY (ServiceName, TimestampTime, Timestamp)                                                 ↴│
   │↳SETTINGS index_granularity = 8192, ttl_only_drop_parts = 1                                        │
   └───────────────────────────────────────────────────────────────────────────────────────────────────┘

1 row in set. Elapsed: 0.003 sec.

clickhouse-0.clickhouse-headless.o11y-clickhouse.svc.cluster.local :) SHOW CREATE TABLE otel_traces;

SHOW CREATE TABLE otel_traces

Query id: 912b4fa6-755a-4507-80dc-c167d5a2a646

   ┌─statement─────────────────────────────────────────────────────────────────────────────────────────┐
1. │ CREATE TABLE clickhouse.otel_traces                                                              ↴│
   │↳(                                                                                                ↴│
   │↳    `Timestamp` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                          ↴│
   │↳    `TraceId` String CODEC(ZSTD(1)),                                                             ↴│
   │↳    `SpanId` String CODEC(ZSTD(1)),                                                              ↴│
   │↳    `ParentSpanId` String CODEC(ZSTD(1)),                                                        ↴│
   │↳    `TraceState` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `SpanName` LowCardinality(String) CODEC(ZSTD(1)),                                            ↴│
   │↳    `SpanKind` LowCardinality(String) CODEC(ZSTD(1)),                                            ↴│
   │↳    `ServiceName` LowCardinality(String) CODEC(ZSTD(1)),                                         ↴│
   │↳    `ResourceAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                     ↴│
   │↳    `ScopeName` String CODEC(ZSTD(1)),                                                           ↴│
   │↳    `ScopeVersion` String CODEC(ZSTD(1)),                                                        ↴│
   │↳    `SpanAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                         ↴│
   │↳    `Duration` UInt64 CODEC(ZSTD(1)),                                                            ↴│
   │↳    `StatusCode` LowCardinality(String) CODEC(ZSTD(1)),                                          ↴│
   │↳    `StatusMessage` String CODEC(ZSTD(1)),                                                       ↴│
   │↳    `Events.Timestamp` Array(DateTime64(9)) CODEC(ZSTD(1)),                                      ↴│
   │↳    `Events.Name` Array(LowCardinality(String)) CODEC(ZSTD(1)),                                  ↴│
   │↳    `Events.Attributes` Array(Map(LowCardinality(String), String)) CODEC(ZSTD(1)),               ↴│
   │↳    `Links.TraceId` Array(String) CODEC(ZSTD(1)),                                                ↴│
   │↳    `Links.SpanId` Array(String) CODEC(ZSTD(1)),                                                 ↴│
   │↳    `Links.TraceState` Array(String) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Links.Attributes` Array(Map(LowCardinality(String), String)) CODEC(ZSTD(1)),                ↴│
   │↳    INDEX idx_trace_id TraceId TYPE bloom_filter(0.001) GRANULARITY 1,                           ↴│
   │↳    INDEX idx_res_attr_key mapKeys(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,    ↴│
   │↳    INDEX idx_res_attr_value mapValues(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,↴│
   │↳    INDEX idx_span_attr_key mapKeys(SpanAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,       ↴│
   │↳    INDEX idx_span_attr_value mapValues(SpanAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,   ↴│
   │↳    INDEX idx_duration Duration TYPE minmax GRANULARITY 1                                        ↴│
   │↳)                                                                                                ↴│
   │↳ENGINE = MergeTree                                                                               ↴│
   │↳PARTITION BY toDate(Timestamp)                                                                   ↴│
   │↳ORDER BY (ServiceName, SpanName, toDateTime(Timestamp))                                          ↴│
   │↳SETTINGS index_granularity = 8192, ttl_only_drop_parts = 1                                        │
   └───────────────────────────────────────────────────────────────────────────────────────────────────┘

1 row in set. Elapsed: 0.003 sec.

clickhouse-0.clickhouse-headless.o11y-clickhouse.svc.cluster.local :) SHOW CREATE TABLE otel_metrics_exponential_histogram;

SHOW CREATE TABLE otel_metrics_exponential_histogram

Query id: 4e660560-e330-435f-8ac7-7a25be133aac

   ┌─statement─────────────────────────────────────────────────────────────────────────────────────────┐
1. │ CREATE TABLE clickhouse.otel_metrics_exponential_histogram                                       ↴│
   │↳(                                                                                                ↴│
   │↳    `ResourceAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                     ↴│
   │↳    `ResourceSchemaUrl` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `ScopeName` String CODEC(ZSTD(1)),                                                           ↴│
   │↳    `ScopeVersion` String CODEC(ZSTD(1)),                                                        ↴│
   │↳    `ScopeAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                        ↴│
   │↳    `ScopeDroppedAttrCount` UInt32 CODEC(ZSTD(1)),                                               ↴│
   │↳    `ScopeSchemaUrl` String CODEC(ZSTD(1)),                                                      ↴│
   │↳    `ServiceName` LowCardinality(String) CODEC(ZSTD(1)),                                         ↴│
   │↳    `MetricName` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `MetricDescription` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `MetricUnit` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `Attributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                             ↴│
   │↳    `StartTimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                      ↴│
   │↳    `TimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                           ↴│
   │↳    `Count` UInt64 CODEC(Delta(8), ZSTD(1)),                                                     ↴│
   │↳    `Sum` Float64 CODEC(ZSTD(1)),                                                                ↴│
   │↳    `Scale` Int32 CODEC(ZSTD(1)),                                                                ↴│
   │↳    `ZeroCount` UInt64 CODEC(ZSTD(1)),                                                           ↴│
   │↳    `PositiveOffset` Int32 CODEC(ZSTD(1)),                                                       ↴│
   │↳    `PositiveBucketCounts` Array(UInt64) CODEC(ZSTD(1)),                                         ↴│
   │↳    `NegativeOffset` Int32 CODEC(ZSTD(1)),                                                       ↴│
   │↳    `NegativeBucketCounts` Array(UInt64) CODEC(ZSTD(1)),                                         ↴│
   │↳    `Exemplars.FilteredAttributes` Array(Map(LowCardinality(String), String)) CODEC(ZSTD(1)),    ↴│
   │↳    `Exemplars.TimeUnix` Array(DateTime64(9)) CODEC(ZSTD(1)),                                    ↴│
   │↳    `Exemplars.Value` Array(Float64) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Exemplars.SpanId` Array(String) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Exemplars.TraceId` Array(String) CODEC(ZSTD(1)),                                            ↴│
   │↳    `Flags` UInt32 CODEC(ZSTD(1)),                                                               ↴│
   │↳    `Min` Float64 CODEC(ZSTD(1)),                                                                ↴│
   │↳    `Max` Float64 CODEC(ZSTD(1)),                                                                ↴│
   │↳    `AggregationTemporality` Int32 CODEC(ZSTD(1)),                                               ↴│
   │↳    INDEX idx_res_attr_key mapKeys(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,    ↴│
   │↳    INDEX idx_res_attr_value mapValues(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,↴│
   │↳    INDEX idx_scope_attr_key mapKeys(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,     ↴│
   │↳    INDEX idx_scope_attr_value mapValues(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1, ↴│
   │↳    INDEX idx_attr_key mapKeys(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1,                ↴│
   │↳    INDEX idx_attr_value mapValues(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1             ↴│
   │↳)                                                                                                ↴│
   │↳ENGINE = MergeTree                                                                               ↴│
   │↳PARTITION BY toDate(TimeUnix)                                                                    ↴│
   │↳ORDER BY (ServiceName, MetricName, Attributes, toUnixTimestamp64Nano(TimeUnix))                  ↴│
   │↳SETTINGS index_granularity = 8192, ttl_only_drop_parts = 1                                        │
   └───────────────────────────────────────────────────────────────────────────────────────────────────┘

1 row in set. Elapsed: 0.003 sec.

clickhouse-0.clickhouse-headless.o11y-clickhouse.svc.cluster.local :) SHOW CREATE TABLE otel_metrics_gauge;

SHOW CREATE TABLE otel_metrics_gauge

Query id: 4e056289-902e-4326-b1fe-c4903c0c72e0

   ┌─statement─────────────────────────────────────────────────────────────────────────────────────────┐
1. │ CREATE TABLE clickhouse.otel_metrics_gauge                                                       ↴│
   │↳(                                                                                                ↴│
   │↳    `ResourceAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                     ↴│
   │↳    `ResourceSchemaUrl` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `ScopeName` String CODEC(ZSTD(1)),                                                           ↴│
   │↳    `ScopeVersion` String CODEC(ZSTD(1)),                                                        ↴│
   │↳    `ScopeAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                        ↴│
   │↳    `ScopeDroppedAttrCount` UInt32 CODEC(ZSTD(1)),                                               ↴│
   │↳    `ScopeSchemaUrl` String CODEC(ZSTD(1)),                                                      ↴│
   │↳    `ServiceName` LowCardinality(String) CODEC(ZSTD(1)),                                         ↴│
   │↳    `MetricName` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `MetricDescription` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `MetricUnit` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `Attributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                             ↴│
   │↳    `StartTimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                      ↴│
   │↳    `TimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                           ↴│
   │↳    `Value` Float64 CODEC(ZSTD(1)),                                                              ↴│
   │↳    `Flags` UInt32 CODEC(ZSTD(1)),                                                               ↴│
   │↳    `Exemplars.FilteredAttributes` Array(Map(LowCardinality(String), String)) CODEC(ZSTD(1)),    ↴│
   │↳    `Exemplars.TimeUnix` Array(DateTime64(9)) CODEC(ZSTD(1)),                                    ↴│
   │↳    `Exemplars.Value` Array(Float64) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Exemplars.SpanId` Array(String) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Exemplars.TraceId` Array(String) CODEC(ZSTD(1)),                                            ↴│
   │↳    INDEX idx_res_attr_key mapKeys(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,    ↴│
   │↳    INDEX idx_res_attr_value mapValues(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,↴│
   │↳    INDEX idx_scope_attr_key mapKeys(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,     ↴│
   │↳    INDEX idx_scope_attr_value mapValues(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1, ↴│
   │↳    INDEX idx_attr_key mapKeys(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1,                ↴│
   │↳    INDEX idx_attr_value mapValues(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1             ↴│
   │↳)                                                                                                ↴│
   │↳ENGINE = MergeTree                                                                               ↴│
   │↳PARTITION BY toDate(TimeUnix)                                                                    ↴│
   │↳ORDER BY (ServiceName, MetricName, Attributes, toUnixTimestamp64Nano(TimeUnix))                  ↴│
   │↳SETTINGS index_granularity = 8192, ttl_only_drop_parts = 1                                        │
   └───────────────────────────────────────────────────────────────────────────────────────────────────┘

1 row in set. Elapsed: 0.004 sec.

clickhouse-0.clickhouse-headless.o11y-clickhouse.svc.cluster.local :) SHOW CREATE TABLE otel_metrics_histogram;

SHOW CREATE TABLE otel_metrics_histogram

Query id: 8ba68cac-988e-4525-a1c5-9324da663287

   ┌─statement─────────────────────────────────────────────────────────────────────────────────────────┐
1. │ CREATE TABLE clickhouse.otel_metrics_histogram                                                   ↴│
   │↳(                                                                                                ↴│
   │↳    `ResourceAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                     ↴│
   │↳    `ResourceSchemaUrl` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `ScopeName` String CODEC(ZSTD(1)),                                                           ↴│
   │↳    `ScopeVersion` String CODEC(ZSTD(1)),                                                        ↴│
   │↳    `ScopeAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                        ↴│
   │↳    `ScopeDroppedAttrCount` UInt32 CODEC(ZSTD(1)),                                               ↴│
   │↳    `ScopeSchemaUrl` String CODEC(ZSTD(1)),                                                      ↴│
   │↳    `ServiceName` LowCardinality(String) CODEC(ZSTD(1)),                                         ↴│
   │↳    `MetricName` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `MetricDescription` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `MetricUnit` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `Attributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                             ↴│
   │↳    `StartTimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                      ↴│
   │↳    `TimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                           ↴│
   │↳    `Count` UInt64 CODEC(Delta(8), ZSTD(1)),                                                     ↴│
   │↳    `Sum` Float64 CODEC(ZSTD(1)),                                                                ↴│
   │↳    `BucketCounts` Array(UInt64) CODEC(ZSTD(1)),                                                 ↴│
   │↳    `ExplicitBounds` Array(Float64) CODEC(ZSTD(1)),                                              ↴│
   │↳    `Exemplars.FilteredAttributes` Array(Map(LowCardinality(String), String)) CODEC(ZSTD(1)),    ↴│
   │↳    `Exemplars.TimeUnix` Array(DateTime64(9)) CODEC(ZSTD(1)),                                    ↴│
   │↳    `Exemplars.Value` Array(Float64) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Exemplars.SpanId` Array(String) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Exemplars.TraceId` Array(String) CODEC(ZSTD(1)),                                            ↴│
   │↳    `Flags` UInt32 CODEC(ZSTD(1)),                                                               ↴│
   │↳    `Min` Float64 CODEC(ZSTD(1)),                                                                ↴│
   │↳    `Max` Float64 CODEC(ZSTD(1)),                                                                ↴│
   │↳    `AggregationTemporality` Int32 CODEC(ZSTD(1)),                                               ↴│
   │↳    INDEX idx_res_attr_key mapKeys(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,    ↴│
   │↳    INDEX idx_res_attr_value mapValues(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,↴│
   │↳    INDEX idx_scope_attr_key mapKeys(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,     ↴│
   │↳    INDEX idx_scope_attr_value mapValues(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1, ↴│
   │↳    INDEX idx_attr_key mapKeys(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1,                ↴│
   │↳    INDEX idx_attr_value mapValues(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1             ↴│
   │↳)                                                                                                ↴│
   │↳ENGINE = MergeTree                                                                               ↴│
   │↳PARTITION BY toDate(TimeUnix)                                                                    ↴│
   │↳ORDER BY (ServiceName, MetricName, Attributes, toUnixTimestamp64Nano(TimeUnix))                  ↴│
   │↳SETTINGS index_granularity = 8192, ttl_only_drop_parts = 1                                        │
   └───────────────────────────────────────────────────────────────────────────────────────────────────┘

1 row in set. Elapsed: 0.026 sec.

clickhouse-0.clickhouse-headless.o11y-clickhouse.svc.cluster.local :) SHOW CREATE TABLE otel_metrics_sum;

SHOW CREATE TABLE otel_metrics_sum

Query id: b502c97a-951f-4f73-bae8-32e789a75e23

   ┌─statement─────────────────────────────────────────────────────────────────────────────────────────┐
1. │ CREATE TABLE clickhouse.otel_metrics_sum                                                         ↴│
   │↳(                                                                                                ↴│
   │↳    `ResourceAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                     ↴│
   │↳    `ResourceSchemaUrl` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `ScopeName` String CODEC(ZSTD(1)),                                                           ↴│
   │↳    `ScopeVersion` String CODEC(ZSTD(1)),                                                        ↴│
   │↳    `ScopeAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                        ↴│
   │↳    `ScopeDroppedAttrCount` UInt32 CODEC(ZSTD(1)),                                               ↴│
   │↳    `ScopeSchemaUrl` String CODEC(ZSTD(1)),                                                      ↴│
   │↳    `ServiceName` LowCardinality(String) CODEC(ZSTD(1)),                                         ↴│
   │↳    `MetricName` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `MetricDescription` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `MetricUnit` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `Attributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                             ↴│
   │↳    `StartTimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                      ↴│
   │↳    `TimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                           ↴│
   │↳    `Value` Float64 CODEC(ZSTD(1)),                                                              ↴│
   │↳    `Flags` UInt32 CODEC(ZSTD(1)),                                                               ↴│
   │↳    `Exemplars.FilteredAttributes` Array(Map(LowCardinality(String), String)) CODEC(ZSTD(1)),    ↴│
   │↳    `Exemplars.TimeUnix` Array(DateTime64(9)) CODEC(ZSTD(1)),                                    ↴│
   │↳    `Exemplars.Value` Array(Float64) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Exemplars.SpanId` Array(String) CODEC(ZSTD(1)),                                             ↴│
   │↳    `Exemplars.TraceId` Array(String) CODEC(ZSTD(1)),                                            ↴│
   │↳    `AggregationTemporality` Int32 CODEC(ZSTD(1)),                                               ↴│
   │↳    `IsMonotonic` Bool CODEC(Delta(1), ZSTD(1)),                                                 ↴│
   │↳    INDEX idx_res_attr_key mapKeys(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,    ↴│
   │↳    INDEX idx_res_attr_value mapValues(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,↴│
   │↳    INDEX idx_scope_attr_key mapKeys(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,     ↴│
   │↳    INDEX idx_scope_attr_value mapValues(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1, ↴│
   │↳    INDEX idx_attr_key mapKeys(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1,                ↴│
   │↳    INDEX idx_attr_value mapValues(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1             ↴│
   │↳)                                                                                                ↴│
   │↳ENGINE = MergeTree                                                                               ↴│
   │↳PARTITION BY toDate(TimeUnix)                                                                    ↴│
   │↳ORDER BY (ServiceName, MetricName, Attributes, toUnixTimestamp64Nano(TimeUnix))                  ↴│
   │↳SETTINGS index_granularity = 8192, ttl_only_drop_parts = 1                                        │
   └───────────────────────────────────────────────────────────────────────────────────────────────────┘

1 row in set. Elapsed: 0.003 sec.

clickhouse-0.clickhouse-headless.o11y-clickhouse.svc.cluster.local :) SHOW CREATE TABLE otel_metrics_summary;

SHOW CREATE TABLE otel_metrics_summary

Query id: 88c06253-871f-479a-86a5-1c4c8989cef9

   ┌─statement─────────────────────────────────────────────────────────────────────────────────────────┐
1. │ CREATE TABLE clickhouse.otel_metrics_summary                                                     ↴│
   │↳(                                                                                                ↴│
   │↳    `ResourceAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                     ↴│
   │↳    `ResourceSchemaUrl` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `ScopeName` String CODEC(ZSTD(1)),                                                           ↴│
   │↳    `ScopeVersion` String CODEC(ZSTD(1)),                                                        ↴│
   │↳    `ScopeAttributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                        ↴│
   │↳    `ScopeDroppedAttrCount` UInt32 CODEC(ZSTD(1)),                                               ↴│
   │↳    `ScopeSchemaUrl` String CODEC(ZSTD(1)),                                                      ↴│
   │↳    `ServiceName` LowCardinality(String) CODEC(ZSTD(1)),                                         ↴│
   │↳    `MetricName` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `MetricDescription` String CODEC(ZSTD(1)),                                                   ↴│
   │↳    `MetricUnit` String CODEC(ZSTD(1)),                                                          ↴│
   │↳    `Attributes` Map(LowCardinality(String), String) CODEC(ZSTD(1)),                             ↴│
   │↳    `StartTimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                      ↴│
   │↳    `TimeUnix` DateTime64(9) CODEC(Delta(8), ZSTD(1)),                                           ↴│
   │↳    `Count` UInt64 CODEC(Delta(8), ZSTD(1)),                                                     ↴│
   │↳    `Sum` Float64 CODEC(ZSTD(1)),                                                                ↴│
   │↳    `ValueAtQuantiles.Quantile` Array(Float64) CODEC(ZSTD(1)),                                   ↴│
   │↳    `ValueAtQuantiles.Value` Array(Float64) CODEC(ZSTD(1)),                                      ↴│
   │↳    `Flags` UInt32 CODEC(ZSTD(1)),                                                               ↴│
   │↳    INDEX idx_res_attr_key mapKeys(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,    ↴│
   │↳    INDEX idx_res_attr_value mapValues(ResourceAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,↴│
   │↳    INDEX idx_scope_attr_key mapKeys(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1,     ↴│
   │↳    INDEX idx_scope_attr_value mapValues(ScopeAttributes) TYPE bloom_filter(0.01) GRANULARITY 1, ↴│
   │↳    INDEX idx_attr_key mapKeys(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1,                ↴│
   │↳    INDEX idx_attr_value mapValues(Attributes) TYPE bloom_filter(0.01) GRANULARITY 1             ↴│
   │↳)                                                                                                ↴│
   │↳ENGINE = MergeTree                                                                               ↴│
   │↳PARTITION BY toDate(TimeUnix)                                                                    ↴│
   │↳ORDER BY (ServiceName, MetricName, Attributes, toUnixTimestamp64Nano(TimeUnix))                  ↴│
   │↳SETTINGS index_granularity = 8192, ttl_only_drop_parts = 1                                        │
   └───────────────────────────────────────────────────────────────────────────────────────────────────┘

1 row in set. Elapsed: 0.009 sec.
```
