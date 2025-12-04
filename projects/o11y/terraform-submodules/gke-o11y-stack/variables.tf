variable "google_project" {
  type = object({
    project_id = string
  })
}

variable "blackbox_exporter_urls" {
  type    = set(string)
  default = []
}
