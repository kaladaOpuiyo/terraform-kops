resource "helm_release" "fluentd_elasticsearch" {
  count     = "${var.install_utilities == true ? 1: 0}"
  name      = "fluentd-elasticsearch"
  chart     = "stable/fluentd-elasticsearch"
  namespace = "${var.tiller_namespace}"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}

resource "kubernetes_cluster_role_binding" "fluentd_elasticsearch" {
  count = "${var.install_utilities == true ? 1: 0}"

  metadata {
    name = "fluentd-elasticsearch"
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
    name      = "fluentd-elasticsearch"
    namespace = "kube-system"
    api_group = ""
  }

  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}
