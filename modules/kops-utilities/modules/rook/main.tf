resource "helm_repository" "rook_beta" {
  name = "rock-beta"
  url  = "https://charts.rook.io/beta"
}

resource "helm_release" "rook_beta" {
  name       = "rook-system"
  chart      = "rook-beta/rook-ceph"
  repository = "${helm_repository.rook_beta.metadata.0.name}"

  namespace = "rook"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}

resource "kubernetes_cluster_role_binding" "rook_stable" {
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
