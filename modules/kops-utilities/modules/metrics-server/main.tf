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
    value = "v0.3.1"
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

# resource "kubernetes_cluster_role_binding" "metrics_server" {
#   metadata {
#     name = "metrics-server"
#   }


#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#   }


#   subject {
#     kind      = "User"
#     name      = "admin"
#     api_group = "rbac.authorization.k8s.io"
#   }


#   subject {
#     kind      = "ServiceAccount"
#     name      = "metrics-server"
#     namespace = "kube-system"
#     api_group = ""
#   }


#   subject {
#     kind      = "Group"
#     name      = "system:masters"
#     api_group = "rbac.authorization.k8s.io"
#   }
# }

