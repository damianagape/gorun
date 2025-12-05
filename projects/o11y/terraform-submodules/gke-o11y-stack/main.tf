#######################################
### clickhouse
#######################################

resource "kubernetes_namespace" "clickhouse" {
  metadata {
    name = "o11y-clickhouse"
  }
}

resource "helm_release" "clickhouse" {
  repository = "../../../core/helm-charts" # "oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts/gorun/core"
  chart      = "clickhouse"
  version    = "0.7.100"

  name      = "clickhouse"
  namespace = kubernetes_namespace.clickhouse.metadata[0].name

  values = [templatefile("${path.module}/assets/clickhouse.yaml.tftpl", {
  })]

  lifecycle {
    prevent_destroy = true
  }
}

#######################################
### grafana
#######################################

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "o11y-grafana"
  }
}

resource "helm_release" "grafana_postgres" {
  repository = "../../../core/helm-charts" # "oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts/gorun/core"
  chart      = "postgres"
  version    = "0.7.100"

  name      = "postgres"
  namespace = kubernetes_namespace.grafana.metadata[0].name

  values = [templatefile("${path.module}/assets/grafana_postgres.yaml.tftpl", {
  })]

  lifecycle {
    prevent_destroy = true
  }
}

# resource "helm_release" "grafana" {
#   repository = "${path.module}/helm/charts"
#   chart      = "grafana"

#   name      = "grafana"
#   namespace = kubernetes_namespace.grafana.metadata[0].name

#   values = [
#     file("${path.module}/helm/values/grafana.yaml"),
#     templatefile("${path.module}/assets/grafana.yaml.tftpl", {
#       grafana_domain        = var.grafana_domain
#       grafana_smtp_host     = nonsensitive(data.kubernetes_secret.grafana_smtp.data["host"])
#       grafana_smtp_username = nonsensitive(data.kubernetes_secret.grafana_smtp.data["username"])
#       grafana_email         = var.grafana_email
#       grafana_admin_email   = "dagape.test@gmail.com"
#       grafana_postgres_host = "${helm_release.grafana_postgres.name}.${helm_release.grafana_postgres.namespace}.svc.cluster.local"
#     }),
#   ]

#   set_sensitive = [{
#     # grafana_smtp_password
#     name  = "grafana\\.ini.smtp.password"
#     type  = "string"
#     value = data.kubernetes_secret.grafana_smtp.data["password"]
#   }]
# }

# data "kubernetes_service" "grafana" {
#   metadata {
#     name      = helm_release.grafana.name
#     namespace = helm_release.grafana.namespace
#   }
# }

# module "grafana_gateway_http_route" {
#   source = "../../../core/terraform-submodules/k8s-gateway-http-route" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-gateway-http-route/0.7.100.zip"

#   kubernetes_service = data.kubernetes_service.grafana

#   domain            = var.grafana_domain
#   service_port      = 80
#   container_port    = 3000
#   health_check_path = "/healthz"
# }

module "grafana_availability_monitor" {
  source = "../gcp-availability-monitor" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/o11y/gcp-availability-monitor/0.7.100.zip"

  google_project = var.google_project

  request_host     = var.grafana_domain
  request_path     = "/healthz"
  response_content = "Ok"

  notification_emails = ["dagape.test@gmail.com"]
}

#######################################
### otlp collector
#######################################

resource "kubernetes_namespace" "otlp_collector" {
  metadata {
    name = "o11y-otlp-collector"
  }
}

resource "helm_release" "otlp_collector" {
  repository = "../../helm-charts" # "oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts/gorun/o11y"
  chart      = "otelcol"
  version    = "0.7.100"

  name      = "otlp"
  namespace = kubernetes_namespace.otlp_collector.metadata[0].name

  values = [templatefile("${path.module}/assets/otlp_collector.yaml.tftpl", {
    clickhouse_endpoint = local.clickhouse_endpoint
  })]
}

#######################################
### file collector
#######################################

resource "kubernetes_namespace" "file_collector" {
  metadata {
    name = "o11y-file-collector"
  }
}

resource "helm_release" "file_collector" {
  repository = "../../helm-charts" # "oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts/gorun/o11y"
  chart      = "otelcol"
  version    = "0.7.100"

  name      = "file"
  namespace = kubernetes_namespace.file_collector.metadata[0].name

  values = [templatefile("${path.module}/assets/file_collector.yaml.tftpl", {
    clickhouse_endpoint = local.clickhouse_endpoint
  })]
}

#######################################
### kube collector
#######################################

resource "kubernetes_namespace" "kube_collector" {
  metadata {
    name = "o11y-kube-collector"
  }
}

resource "helm_release" "kube_collector" {
  repository = "../../helm-charts" # "oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts/gorun/o11y"
  chart      = "otelcol"
  version    = "0.7.100"

  name      = "kube"
  namespace = kubernetes_namespace.kube_collector.metadata[0].name

  values = [templatefile("${path.module}/assets/kube_collector.yaml.tftpl", {
    clickhouse_endpoint = local.clickhouse_endpoint
  })]
}

#######################################
### node collector
#######################################

resource "kubernetes_namespace" "node_collector" {
  metadata {
    name = "o11y-node-collector"
  }
}

resource "helm_release" "node_collector" {
  repository = "../../helm-charts" # "oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts/gorun/o11y"
  chart      = "otelcol"
  version    = "0.7.100"

  name      = "node"
  namespace = kubernetes_namespace.node_collector.metadata[0].name

  values = [templatefile("${path.module}/assets/node_collector.yaml.tftpl", {
    clickhouse_endpoint = local.clickhouse_endpoint
  })]
}

#######################################
### prom collector
#######################################

resource "kubernetes_namespace" "prom_collector" {
  metadata {
    name = "o11y-prom-collector"
  }
}

resource "helm_release" "prom_collector" {
  repository = "../../helm-charts" # "oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts/gorun/o11y"
  chart      = "otelcol"
  version    = "0.7.100"

  name      = "prom"
  namespace = kubernetes_namespace.prom_collector.metadata[0].name

  values = [templatefile("${path.module}/assets/prom_collector.yaml.tftpl", {
    clickhouse_endpoint = local.clickhouse_endpoint
  })]
}

#######################################
### blackbox exporter
#######################################

resource "kubernetes_namespace" "blackbox_exporter" {
  metadata {
    name = "o11y-blackbox-exporter"
  }
}

resource "helm_release" "blackbox_exporter" {
  repository = "${path.module}/helm/charts"
  chart      = "prometheus-blackbox-exporter"

  name      = "prometheus-blackbox-exporter"
  namespace = kubernetes_namespace.blackbox_exporter.metadata[0].name

  values = [
    file("${path.module}/helm/values/prometheus-blackbox-exporter.yaml"),
    templatefile("${path.module}/assets/blackbox_exporter.yaml.tftpl", {
      urls = var.blackbox_exporter_urls
    }),
  ]
}
