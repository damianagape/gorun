#!/bin/bash
set -e

function main {
  helm template "bar" --namespace="foo" \
     "./docs/decisions/0003-otel-backend/grafana/projects/o11y/terraform-modules/test/helm/charts/opentelemetry-collector" \
     --values="./docs/decisions/0003-otel-backend/clickstack-helm-render/daemonset.values.yaml" \
     > "docs/decisions/0003-otel-backend/clickstack-helm-render/daemonset.render.yaml"

  helm template "baz" --namespace="foo" \
     "./docs/decisions/0003-otel-backend/grafana/projects/o11y/terraform-modules/test/helm/charts/opentelemetry-collector" \
     --values="./docs/decisions/0003-otel-backend/clickstack-helm-render/deployment.values.yaml" \
     > "docs/decisions/0003-otel-backend/clickstack-helm-render/deployment.render.yaml"
}

main "$@"
