resource "kubernetes_namespace" "clickstack" {
  metadata {
    name = "o11y-clickstack"
  }

  timeouts {
    delete = "20m"
  }
}

resource "helm_release" "clickstack" {
  repository = "${path.module}/helm/charts"
  chart      = "clickstack"
  name       = "clickstack"
  namespace  = kubernetes_namespace.clickstack.metadata[0].name

  values = [
    file("${path.module}/helm/values/clickstack.yaml"),
    templatefile("${path.module}/assets/clickstack.yaml.tftpl", {
      hyperdx_domain = var.hyperdx_domain
    }),
  ]

  lifecycle {
    # TODO true
    prevent_destroy = false
  }
}

# data "kubernetes_service" "clickstack" {
#   metadata {
#     name      = helm_release.clickstack.metadata.name
#     namespace = helm_release.clickstack.metadata.namespace
#   }
# }

# module "clickstack_gateway_http_route" {
#   source = "../../../core/terraform-submodules/k8s-gateway-http-route" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-2-private-terraform-modules/gorun/core/k8s-gateway-http-route/0.3.100.zip"
#
#   kubernetes_service = data.kubernetes_service.clickstack
#
#   domain            = var.clickstack_domain
#   service_port      = 8080
#   container_port    = 8080
#   health_check_path = "/api/v1/health"
# }
