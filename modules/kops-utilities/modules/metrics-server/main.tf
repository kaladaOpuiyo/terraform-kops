resource "helm_release" "metrics_server" {
  count = "${var.install_utilities}"
  name  = "metrics-server"
  chart = "stable/metrics-server"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}
