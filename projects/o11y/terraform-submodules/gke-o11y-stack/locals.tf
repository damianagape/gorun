locals {
  clickhouse_endpoint = "tcp://${helm_release.clickhouse.name}-0.${helm_release.clickhouse.name}-headless.${helm_release.clickhouse.namespace}.svc.cluster.local:9000"
}

data "kubernetes_secret" "grafana_smtp" {
  metadata {
    name      = "smtp"
    namespace = "vault-grafana"
  }
}
