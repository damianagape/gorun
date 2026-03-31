locals {
  short_project_types = {
    "docker-images"        = "image"
    "helm-charts"          = "chart"
    "helm-releases"        = "release"
    "terraform-submodules" = "tfsub"
    "terraform-modules"    = "tfmod"
  }

  projects = [
    for _, v in fileset("${path.module}/../../../../projects", "**/.project.yaml") :
    {
      project_path = join("/", [
        "projects",
        split("/", v)[0],
        split("/", v)[1],
        split("/", v)[2],
      ])
      project_slug = join("-", [
        split("/", v)[0],
        local.short_project_types[split("/", v)[1]],
        split("/", v)[2],
      ])
      project_scope = split("/", v)[0]
      project_type  = split("/", v)[1]
      project_name  = split("/", v)[2]
    }
  ]
}
