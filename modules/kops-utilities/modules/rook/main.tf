resource "helm_release" "rook" {
  count     = "${var.install_utilities}"
  name      = "rook"
  chart     = "http://charts.rook.io/stable"
  namespace = "${var.tiller_namespace}"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}

resource "kubernetes_cluster_role_binding" "rook" {
  count = "${var.install_utilities}"

  metadata {
    name = "rook"
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
    name      = "rook"
    namespace = "kube-system"
    api_group = ""
  }

  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}
