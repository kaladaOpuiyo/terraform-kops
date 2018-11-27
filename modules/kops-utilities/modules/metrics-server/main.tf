resource "helm_release" "metrics_server" {
  count = "${var.install_utilities  ? 1: 0}"

  name      = "metrics-server"
  chart     = "stable/metrics-server"
  namespace = "${var.tiller_namespace}"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}

resource "kubernetes_cluster_role_binding" "metrics_server" {
  count = "${var.install_utilities  ? 1: 0}"

  metadata {
    name = "metrics-server"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
    api_group = ""
  }

  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}
