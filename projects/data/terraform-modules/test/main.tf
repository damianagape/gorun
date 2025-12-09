resource "kubernetes_namespace" "kubeflow" {
  metadata {
    name = "data-kubeflow"
  }
}
