module "vault" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-vault/0.7.100.zip"
  source = "../../../core/terraform-submodules/k8s-vault"

  vault_name = "kuard"

  iam_readers = [
    "user:dagape.test@gmail.com",
  ]
  iam_writers = [
  ]
}

module "this" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/demo/kuard/0.7.100.zip"
  source = "../../terraform-submodules/kuard"

  google_project           = data.google_project.this
  google_container_cluster = data.google_container_cluster.this

  platform_domain = "gogke-test-7.damianagape.pl"
}
