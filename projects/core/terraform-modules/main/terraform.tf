terraform {
  required_version = ">= 1.9.6, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0.0, < 8.0.0"
    }
  }

  backend "gcs" {
    bucket = "gogcp-main-7-terraform-state"
    prefix = "github.com/damianagape/gorun/projects/core/terraform-modules/main"
  }
}
