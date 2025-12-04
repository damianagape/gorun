#######################################
### Vaults
#######################################

module "grafana_vault" {
  source = "../../../core/terraform-submodules/k8s-vault" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-vault/0.7.100.zip"

  vault_name = "grafana"

  iam_readers = [
    "user:dagape.test@gmail.com",
  ]
  iam_writers = [
  ]
}

#######################################
### OpenTelemetry Operator
#######################################

resource "kubernetes_namespace" "opentelemetry_operator" {
  metadata {
    name = "opentelemetry-operator"
  }
}

resource "helm_release" "opentelemetry_operator" {
  repository = "${path.module}/helm/charts"
  chart      = "opentelemetry-operator"
  name       = "opentelemetry-operator"
  namespace  = kubernetes_namespace.opentelemetry_operator.metadata[0].name

  values = [
    file("${path.module}/helm/values/opentelemetry-operator.yaml"),
    templatefile("${path.module}/assets/opentelemetry_operator.yaml.tftpl", {
    }),
  ]
}

#######################################
### Observability stack
#######################################

module "test_o11y_stack" {
  source = "../../terraform-submodules/gke-o11y-stack" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/o11y/gke-o11y-stack/0.7.100.zip"

  google_project = data.google_project.this
}
