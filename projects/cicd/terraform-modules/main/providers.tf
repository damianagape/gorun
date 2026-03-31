provider "github" {
}

data "github_repository" "gorun" {
  full_name = "damianagape/gorun"
}

provider "google" {
  project = "gogcp-main-8"
}

data "google_project" "this" {
}
