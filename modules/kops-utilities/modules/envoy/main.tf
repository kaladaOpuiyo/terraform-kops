resource "helm_release" "envoy" {
  name      = "envoy"
  chart     = "stable/envoy"
  namespace = "${var.tiller_namespace}"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}

# resource "kubernetes_cluster_role_binding" "envoy" {
#


#   metadata {
#     name = "envoy"
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
#     name      = "envoy"
#     namespace = "kube-system"
#     api_group = ""
#   }


#   subject {
#     kind      = "Group"
#     name      = "system:masters"
#     api_group = "rbac.authorization.k8s.io"
#   }
# }

