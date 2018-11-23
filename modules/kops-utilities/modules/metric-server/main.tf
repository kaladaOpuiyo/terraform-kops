resource "helm_release" "metric_server" {
  name  = "k8s-dashboard"
  chart = "stable/metrics-server"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}
