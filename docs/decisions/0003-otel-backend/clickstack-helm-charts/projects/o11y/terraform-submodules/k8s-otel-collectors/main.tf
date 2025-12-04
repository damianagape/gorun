resource "kubernetes_namespace" "otel_collectors" {
  metadata {
    name = "o11y-otel-collectors"
  }
}

resource "helm_release" "otel_collectors" {
  repository = "../../helm-charts" # "oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts/gorun/o11y"
  chart      = "otel-collectors"
  version    = "0.7.100"

  name      = "otel-collectors"
  namespace = kubernetes_namespace.otel_collectors.metadata[0].name

  set = [
    { name = "clickstack_endpoint", value = var.clickstack_endpoint },
  ]
  set_sensitive = [
    { name = "clickstack_api_key", value = var.clickstack_api_key },
  ]
}
