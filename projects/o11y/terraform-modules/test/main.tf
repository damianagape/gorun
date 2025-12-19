#######################################
### Vaults
#######################################

module "grafana_vault" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-vault/0.7.100.zip"
  source = "../../../core/terraform-submodules/k8s-vault"

  vault_name = "grafana"

  iam_readers = [
    "user:dagape.test@gmail.com",
  ]
  iam_writers = [
  ]
}

#######################################
### Observability stack
#######################################

module "test_o11y_stack" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/o11y/gke-observability-stack/0.7.100.zip"
  source = "../../terraform-submodules/gke-observability-stack"

  google_project           = data.google_project.this
  google_container_cluster = data.google_container_cluster.this

  grafana_domain = "grafana.gogke-test-7.damianagape.pl"
  grafana_email  = "grafana@gogke-test-7.damianagape.pl"

  blackbox_exporter_urls = [
    "https://grafana.gogke-test-7.damianagape.pl/healthz",
    "https://stateful-kuard.gogke-test-7.damianagape.pl/healthy",
    "https://stateless-kuard.gogke-test-7.damianagape.pl/healthy",
  ]
}
