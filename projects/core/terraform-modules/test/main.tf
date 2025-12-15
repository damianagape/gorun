#######################################
### Platforms
#######################################

module "test_platform" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/gke-platform/0.7.100.zip"
  source = "../../terraform-submodules/gke-platform"

  google_client_config = data.google_client_config.oauth2
  google_project       = data.google_project.this

  platform_name   = "gogke-test-7"
  platform_domain = "gogke-test-7.damianagape.pl"

  node_pools = {
    "spot-pool-1" = {
      node_machine_type   = "e2-standard-2"
      node_spot_instances = true
      node_min_instances  = 1
      node_max_instances  = 1
      node_labels         = {}
      node_taints         = []
    }
  }

  iam_cluster_viewers = [
    "serviceAccount:gha-damianagape-gomod@gogcp-main-7.iam.gserviceaccount.com",
    "user:dagape.test@gmail.com",
  ]
}

#######################################
### Vaults
#######################################

module "test_vault" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-vault/0.7.100.zip"
  source = "../../terraform-submodules/k8s-vault"
  depends_on = [
    module.test_platform,
  ]

  vault_name = "gomod-test-7"

  iam_readers = [
    "serviceAccount:gha-damianagape-gomod@gogcp-main-7.iam.gserviceaccount.com",
  ]
  iam_writers = [
    "user:dagape.test@gmail.com",
  ]
}

#######################################
### Workspaces
#######################################

module "test_workspace" {
  # PROD source = "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-workspace/0.7.100.zip"
  source = "../../terraform-submodules/k8s-workspace" #
  depends_on = [
    module.test_platform,
  ]

  workspace_name = "gomod-test-7"

  iam_testers = [
  ]
  iam_developers = [
    "serviceAccount:gha-damianagape-gomod@gogcp-main-7.iam.gserviceaccount.com",
    "user:dagape.test@gmail.com",
  ]
}
