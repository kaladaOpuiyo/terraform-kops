resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  chart     = "stable/metrics-server"
  namespace = "${var.tiller_namespace}"

  set {
    name  = "image.repository"
    value = "gcr.io/google_containers/metrics-server-amd64"
  }

  set {
    name  = "image.tag"
    value = "v0.3.0"
  }

  set {
    name  = "image.pullPolicy"
    value = "Always"
  }

  set {
    name  = "args"
    value = "{${join(",", var.metrics_server_args)}}"
  }
}
