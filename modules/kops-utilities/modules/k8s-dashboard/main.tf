resource "helm_release" "k8s_dashboard" {
  name  = "k8s-dashboard"
  chart = "stable/kubernetes-dashboard"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}
