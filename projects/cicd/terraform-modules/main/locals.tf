locals {
  projects = [
    for _, v in fileset("${path.module}/../../../../projects", "**/.project.yaml") :
    {
      project_path  = join("/", slice(split("/", v), 0, 3))
      project_slug  = join("-", slice(split("/", v), 0, 3))
      project_scope = split("/", v)[0]
      project_type  = split("/", v)[1]
      project_name  = split("/", v)[2]
    }
  ]
}
output "_projects" {
  value = local.projects
}
