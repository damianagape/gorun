terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0.0, < 8.0.0"
    }
  }

  backend "gcs" {
    bucket = "gogcp-main-8-terraform-state"
    prefix = "github.com/damianagape/gorun/projects/cicd/terraform-modules/main"
  }
}
