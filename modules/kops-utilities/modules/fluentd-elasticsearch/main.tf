resource "helm_release" "fluentd_elasticsearch" {
  name      = "fluentd-elasticsearch"
  chart     = "stable/fluentd-elasticsearch"
  namespace = "${var.tiller_namespace}"
}

resource "kubernetes_cluster_role_binding" "fluentd_elasticsearch" {
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
