# OpenTelemetry backend

## Context and Problem Statement

We need to store and visualize OpenTelemetry signals. Stack requirements:

- open-source,
- self-hosted,
- free for commercial use,
- low resource consumption: CPU, memory, storage,
- easy to deploy and maintain,
- features: logs storage, metrics storage, traces storage, visualization, alerts, OAuth2 support, configuration as code.

## Considered Options

### LGTM stack: Loki, Grafana, Tempo, Mimir

docs:

- [grafana](https://grafana.com/oss/grafana/)
  - [helm chart](https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/)
  - [config](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/)
  - [oauth](https://grafana.com/docs/grafana/latest/setup-grafana/configure-access/configure-authentication/google/)
  - [terraform provider](https://registry.terraform.io/providers/grafana/grafana/latest)
- [loki](https://grafana.com/oss/loki/)
  - [helm chart](https://grafana.com/docs/loki/latest/setup/install/helm/)
  - [config](https://grafana.com/docs/loki/latest/configure/)
  - [gcs](https://grafana.com/docs/loki/latest/configure/storage/#gcp-deployment-gcs-single-store), [more gcs](https://grafana.com/docs/loki/latest/setup/install/helm/configure-storage/)
  - [otel](https://grafana.com/docs/loki/latest/send-data/otel/#configure-the-opentelemetry-collector-to-write-logs-into-loki)
- [mimir](https://grafana.com/oss/mimir/)
  - [helm chart](https://grafana.com/docs/mimir/latest/set-up/helm-chart/), [more helm](https://grafana.com/docs/helm-charts/tempo-distributed/next/get-started-helm-charts/)
  - [config](https://grafana.com/docs/mimir/latest/configure/configuration-parameters/)
  - [gcs](https://grafana.com/docs/mimir/latest/configure/configure-object-storage-backend/#gcs)
  - [otel](https://grafana.com/docs/mimir/latest/configure/configure-otel-collector/#use-the-opentelemetry-protocol)
- [tempo](https://grafana.com/oss/tempo/)
  - [helm chart](https://grafana.com/docs/tempo/latest/set-up-for-tracing/setup-tempo/deploy/kubernetes/helm-chart/)
  - [config](https://grafana.com/docs/tempo/latest/configuration/manifest/)
  - [gcs](https://grafana.com/docs/tempo/latest/configuration/hosted-storage/gcs/)
- [otel](https://grafana.com/oss/opentelemetry/)

pros:

- well-known industry standard
- docs are fine
- components have clear responsibility separation
- good OpenTelemetry and Prometheus support

cons:

- very complex setup and poor Helm charts quality (very poor!)
- version compatibility burden (hope-it-will-work driven development)
- a lot of backing services to manage: PostgreSQL, Minio/GCS/S3, Kafka (something more?)
- 3 different query languages: LogQL, PromQL, TraceQL
- Grafana dashboards as code management is unusable due to import/export and datasources quirks
- bad performance of Loki full-text search

### Elastic stack: Elasticsearch, Kibana, APM Server + Elastic Cloud on Kubernetes (ECK)

docs:

- [eck](https://www.elastic.co/elastic-cloud-kubernetes)
- elasticsearch
  - [crd](https://www.elastic.co/guide/en/cloud-on-k8s/2.16/k8s-api-elasticsearch-k8s-elastic-co-v1.html)
- kibana
  - [crd](https://www.elastic.co/guide/en/cloud-on-k8s/2.16/k8s-api-kibana-k8s-elastic-co-v1.html)
- apm server
  - [crd](https://www.elastic.co/guide/en/cloud-on-k8s/2.16/k8s-api-apm-k8s-elastic-co-v1.html)
  - [config](https://www.elastic.co/docs/solutions/observability/apm/apm-server/configure)
  - [otel](https://www.elastic.co/docs/solutions/observability/apm/opentelemetry/upstream-opentelemetry-collectors-language-sdks)
- [otel](https://www.elastic.co/what-is/opentelemetry)
- [terraform provider](https://registry.terraform.io/providers/elastic/elasticstack/latest)

pros:

- top quality docs, but amount of them is overwhelming
- top quality Kubernetes operator - it's a pleasure to deploy this stack
- one version for all components - no version compatibility burden
- one storage driver, one data format to work with, one scaling mechanism - it's just possible to learn and master this tool; this knowledge is also usable in another places, not just for observability - it's good to know Elasticsearch

cons:

- Java... consumes a lot of memory

### SigNoz

```
$ kubectl get pod
NAME                                          READY   STATUS      RESTARTS        AGE
chi-signoz-clickhouse-cluster-0-0-0           1/1     Running     0               9m5s
signoz-0                                      1/1     Running     0               9m26s
signoz-clickhouse-operator-7df8948f8c-jzb7q   2/2     Running     2 (9m15s ago)   9m26s
signoz-otel-collector-8586c84f59-k9pwc        1/1     Running     0               9m26s
signoz-schema-migrator-async-init-rjvpj       0/1     Completed   0               9m25s
signoz-schema-migrator-sync-init-crv8g        0/1     Completed   0               9m25s
signoz-zookeeper-0                            1/1     Running     0               9m26s

$ kubectl top pod
NAME                                          CPU(cores)   MEMORY(bytes)
chi-signoz-clickhouse-cluster-0-0-0           79m          519Mi
signoz-0                                      2m           55Mi
signoz-clickhouse-operator-7df8948f8c-jzb7q   2m           24Mi
signoz-otel-collector-8586c84f59-k9pwc        3m           24Mi
signoz-zookeeper-0                            9m           750Mi
```

docs:

- [gcp](https://signoz.io/docs/install/kubernetes/gcp/)
- [helm chart](https://github.com/SigNoz/charts/tree/main/charts/signoz)
- [otel](https://signoz.io/docs/opentelemetry-collection-agents/opentelemetry-collector/configuration/)
- [terraform provider](https://registry.terraform.io/providers/SigNoz/signoz/latest)

pros:

- pretty simple setup: SigNoz, ClickHouse, ZooKeeper (on the other hand it would be better to not maintain ZooKeeper...)
- easy deployment; works out-of-the-box

cons:

- todo

## Decision Outcome

todo
