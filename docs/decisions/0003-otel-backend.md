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
  - [helm](https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/)
  - [config](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/)
  - [oauth](https://grafana.com/docs/grafana/latest/setup-grafana/configure-access/configure-authentication/google/)
  - [tf provider](https://registry.terraform.io/providers/grafana/grafana/latest)
- [loki](https://grafana.com/oss/loki/)
  - [helm](https://grafana.com/docs/loki/latest/setup/install/helm/)
  - [config](https://grafana.com/docs/loki/latest/configure/)
  - [gcs](https://grafana.com/docs/loki/latest/configure/storage/#gcp-deployment-gcs-single-store), [more gcs](https://grafana.com/docs/loki/latest/setup/install/helm/configure-storage/)
  - [otel](https://grafana.com/docs/loki/latest/send-data/otel/#configure-the-opentelemetry-collector-to-write-logs-into-loki)
- [mimir](https://grafana.com/oss/mimir/)
  - [helm](https://grafana.com/docs/mimir/latest/set-up/helm-chart/), [more helm](https://grafana.com/docs/helm-charts/tempo-distributed/next/get-started-helm-charts/)
  - [config](https://grafana.com/docs/mimir/latest/configure/configuration-parameters/)
  - [gcs](https://grafana.com/docs/mimir/latest/configure/configure-object-storage-backend/#gcs)
  - [otel](https://grafana.com/docs/mimir/latest/configure/configure-otel-collector/#use-the-opentelemetry-protocol)
- [tempo](https://grafana.com/oss/tempo/)
  - [helm](https://grafana.com/docs/tempo/latest/set-up-for-tracing/setup-tempo/deploy/kubernetes/helm-chart/)
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
- a lot of backing services: PostgreSQL, Minio/GCS/S3, Kafka (something more?)
- 3 different query languages: LogQL, PromQL, TraceQL
- Grafana dashboards as code management is broken by import/export and datasources mapping issues
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
  - [otel](https://www.elastic.co/docs/solutions/observability/apm/opentelemetry)
- [otel](https://www.elastic.co/what-is/opentelemetry)

pros:

- todo

cons:

- Java consumes a lot of memory

### SigNoz

docs:

- [gcp](https://signoz.io/docs/install/kubernetes/gcp/)

pros:

- todo

cons:

- todo

## Decision Outcome

todo
