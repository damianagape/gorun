locals {
  common_config = yamldecode(templatefile("${path.module}/assets/common_config.yaml.tftpl", {
    clickstack_endpoint = var.clickstack_endpoint
  }))
  otlp_config = merge(local.common_config, yamldecode(file("${path.module}/assets/otlp_config.yaml")))
  file_config = merge(local.common_config, yamldecode(file("${path.module}/assets/file_config.yaml")))
  kube_config = merge(local.common_config, yamldecode(file("${path.module}/assets/kube_config.yaml")))
  node_config = merge(local.common_config, yamldecode(file("${path.module}/assets/node_config.yaml")))
  prom_config = merge(local.common_config, yamldecode(file("${path.module}/assets/prom_config.yaml")))

  otlp_collector_host = "${kubernetes_manifest.otlp_collector.manifest.metadata.name}-collector.${kubernetes_manifest.otlp_collector.manifest.metadata.namespace}.svc.cluster.local"
}
