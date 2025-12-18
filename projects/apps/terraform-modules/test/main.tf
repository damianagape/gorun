module "gomod_test_vault" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-vault/0.7.100.zip"
  source = "../../../core/terraform-submodules/k8s-vault"

  vault_name = "gomod-test-7"

  iam_readers = [
  ]
  iam_writers = [
    "serviceAccount:gha-damianagape-gomod@gogcp-main-7.iam.gserviceaccount.com",
    "user:dagape.test@gmail.com",
  ]
}

module "gomod_test_workspace" {
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

data "kubernetes_service" "goapp_test" {
  metadata {
    name      = "goapp-test-7"
    namespace = "gomod-test-7"
  }
}

module "goapp_test_gateway_http_route" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-gateway-http-route/0.7.100.zip"
  source = "../../../core/terraform-submodules/k8s-gateway-http-route"

  kubernetes_service = data.kubernetes_service.goapp_test

  domain            = "goapp.gogke-test-7.damianagape.pl"
  service_port      = 80
  container_port    = 8080
  health_check_path = "/healthy"
}
