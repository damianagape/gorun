locals {
}

data "kubernetes_secret" "grafana_smtp" {
  metadata {
    name      = "smtp"
    namespace = "vault-grafana"
  }
}
