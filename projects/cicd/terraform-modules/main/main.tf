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

resource "google_cloudbuildv2_repository" "this" {
  project           = data.google_project.this.project_id
  location          = local.gcp_region
  parent_connection = google_cloudbuildv2_connection.github.name
  name              = data.github_repository.this.full_name
  remote_uri        = data.github_repository.this.http_clone_url
}

#######################################
### Cloud Build service account
#######################################

resource "google_service_account" "cloud_build" {
  project    = data.google_project.this.project_id
  account_id = "cloud-build"
}

#######################################
### Cloud Build logs bucket
#######################################

resource "google_storage_bucket" "cloud_build_logs" {
  project  = data.google_project.this.project_id
  location = local.gcp_region
  name     = "${data.google_project.this.project_id}-cloud-build-logs"

  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

resource "google_storage_bucket_iam_member" "cloud_build_logs_admin" {
  bucket = google_storage_bucket.cloud_build_logs.name
  role   = "roles/storage.admin"
  member = google_service_account.cloud_build.member
}

#######################################
### GitHub triggers
#######################################

resource "google_cloudbuild_trigger" "push" {
  depends_on = [
    google_storage_bucket_iam_member.cloud_build_logs_admin,
  ]
  for_each = { for _, v in local.projects : v.project_path => v }

  project     = data.google_project.this.project_id
  location    = local.gcp_region
  name        = "${data.github_repository.this.name}-${each.value.project_slug}-push"
  description = "github.com/${data.github_repository.this.full_name}/tree/main/${each.value.project_path}"

  repository_event_config {
    repository = google_cloudbuildv2_repository.this.id
    push {
      branch = "^feature/cloud-build$" # TODO "^main$"
    }
  }
  included_files = ["${each.value.project_path}/**"]
  ignored_files  = ["${each.value.project_path}/README.md"]

  service_account = google_service_account.cloud_build.id
  build {
    dynamic "step" {
      for_each = [
        {
          script = "pwd"
        },
        {
          args = ["echo", "${each.value.project_path}"]
        },
      ]
      content {
        name = "europe-central2-docker.pkg.dev/gogcp-main-8/private-docker-images/gorun/core/devcontainer:0.8.100"

        entrypoint = try(step.value.entrypoint, null)
        args       = try(step.value.args, null)
        script     = try(step.value.script, null)
      }
    }

    options {
      logging = "GCS_ONLY"
    }
    logs_bucket = google_storage_bucket.cloud_build_logs.url
  }
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
}

resource "google_cloudbuild_trigger" "pr" {
  depends_on = [
    google_storage_bucket_iam_member.cloud_build_logs_admin,
  ]
  for_each = { for _, v in local.projects : v.project_path => v }

  project     = data.google_project.this.project_id
  location    = local.gcp_region
  name        = "${data.github_repository.this.name}-${each.value.project_slug}-pr"
  description = "github.com/${data.github_repository.this.full_name}/tree/main/${each.value.project_path}"

  repository_event_config {
    repository = google_cloudbuildv2_repository.this.id
    pull_request {
      branch          = "^main$"
      comment_control = "COMMENTS_ENABLED"
    }
  }
  included_files = ["${each.value.project_path}/**"]
  ignored_files  = ["${each.value.project_path}/README.md"]

  service_account = google_service_account.cloud_build.id
  build {
    dynamic "step" {
      for_each = [
        {
          script = "pwd"
        },
        {
          args = ["echo", "${each.value.project_path}"]
        },
      ]
      content {
        name = "europe-central2-docker.pkg.dev/gogcp-main-8/private-docker-images/gorun/core/devcontainer:0.8.100"

        entrypoint = try(step.value.entrypoint, null)
        args       = try(step.value.args, null)
        script     = try(step.value.script, null)
      }
    }

    options {
      logging = "GCS_ONLY"
    }
    logs_bucket = google_storage_bucket.cloud_build_logs.url
  }
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
}
