#######################################
### Platforms
#######################################

module "test_platform" {
  source = "../../terraform-submodules/gke-platform" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/gke-platform/0.7.100.zip"

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
    "user:dagape.test@gmail.com",
  ]
}

#######################################
### Vaults
#######################################

module "test_vault" {
  source = "../../terraform-submodules/k8s-vault" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-vault/0.7.100.zip"
  depends_on = [
    module.test_platform,
  ]

  vault_name = "gomod-test-7"

  iam_readers = [
  ]
  iam_writers = [
    "user:dagape.test@gmail.com",
  ]
}

module "grafana_vault" {
  source = "../../terraform-submodules/k8s-vault" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-vault/0.7.100.zip"
  depends_on = [
    module.test_platform,
  ]

  vault_name = "grafana"

  iam_readers = [
    "user:dagape.test@gmail.com",
  ]
  iam_writers = [
  ]
}

#######################################
### Workspaces
#######################################

module "test_workspace" {
  source = "../../terraform-submodules/k8s-workspace" # "gcs::https://www.googleapis.com/storage/v1/gogcp-main-7-private-terraform-modules/gorun/core/k8s-workspace/0.7.100.zip"
  depends_on = [
    module.test_platform,
  ]

  workspace_name = "gomod-test-7"

  iam_testers = [
  ]
  iam_developers = [
    "user:dagape.test@gmail.com",
  ]
}
