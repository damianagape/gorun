#######################################
###
#######################################

resource "google_project_iam_member" "secret_manager_admin" {
  project = data.google_project.this.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${local.gsa}"
}

#######################################
### GitHub access token
#######################################

resource "google_secret_manager_secret" "github_token" {
  project   = data.google_project.this.project_id
  secret_id = "github-token"

  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "github_token" {
  secret      = google_secret_manager_secret.github_token.id
  secret_data = var.github_token
}

resource "google_secret_manager_secret_iam_member" "github_token" {
  project   = data.google_project.this.project_id
  secret_id = google_secret_manager_secret.github_token.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.gsa}"
}

#######################################
### GitHub connection
#######################################

resource "google_cloudbuildv2_connection" "github" {
  depends_on = [
    google_secret_manager_secret_iam_member.github_token,
  ]

  project  = data.google_project.this.project_id
  location = local.gcp_region
  name     = "github"

  github_config {
    app_installation_id = local.github_app_installation_id
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token.id
    }
  }
}

#######################################
### GitHub repositories
#######################################

resource "google_cloudbuildv2_repository" "gorun" {
  project           = data.google_project.this.project_id
  location          = local.gcp_region
  parent_connection = google_cloudbuildv2_connection.github.name
  name              = data.github_repository.gorun.full_name
  remote_uri        = data.github_repository.gorun.http_clone_url
}
