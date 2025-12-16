module "test_vault" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-vault/0.7.100.zip"
  source = "../../../core/terraform-submodules/k8s-vault"

  vault_name = "gomod-test-7"

  iam_readers = [
    "serviceAccount:gha-damianagape-gomod@gogcp-main-7.iam.gserviceaccount.com",
  ]
  iam_writers = [
    "user:dagape.test@gmail.com",
  ]
}

module "test_workspace" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-workspace/0.7.100.zip"
  source = "../../../core/terraform-submodules/k8s-workspace"

  workspace_name = "gomod-test-7"

  iam_testers = [
  ]
  iam_developers = [
    "serviceAccount:gha-damianagape-gomod@gogcp-main-7.iam.gserviceaccount.com",
    "user:dagape.test@gmail.com",
  ]
}

data "kubernetes_service" "test" {
  metadata {
    name      = "goapp-test-7-http-server"
    namespace = "gomod-test-7"
  }
}

module "test_gateway_http_route" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-gateway-http-route/0.7.100.zip"
  source = "../../../core/terraform-submodules/k8s-gateway-http-route"

  kubernetes_service = data.kubernetes_service.test

  domain            = "goapp.gogke-test-7.damianagape.pl"
  service_port      = 80
  container_port    = 8080
  health_check_path = "/healthy"
}
