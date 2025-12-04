#######################################
### prometheus-blackbox-exporter
#######################################

resource "kubernetes_namespace" "blackbox_exporter" {
  metadata {
    name = "o11y-blackbox-exporter"
  }
}

resource "helm_release" "blackbox_exporter" {
  repository = "${path.module}/helm/charts"
  chart      = "prometheus-blackbox-exporter"
  name       = "prometheus-blackbox-exporter"
  namespace  = kubernetes_namespace.blackbox_exporter.metadata[0].name

  values = [
    file("${path.module}/helm/values/prometheus-blackbox-exporter.yaml"),
    templatefile("${path.module}/assets/blackbox_exporter.yaml.tftpl", {
      urls = var.blackbox_exporter_urls
    }),
  ]
}
