resource "helm_release" "consul" {
  count     = "${var.install_utilities  ? 1: 0}"
  name      = "consul"
  chart     = "stable/consul"
  namespace = "${var.tiller_namespace}"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}

resource "kubernetes_cluster_role_binding" "consul" {
  count = "${var.install_utilities  ? 1: 0}"

  metadata {
    name = "consul"
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
    name      = "consul"
    namespace = "kube-system"
    api_group = ""
  }

  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}
