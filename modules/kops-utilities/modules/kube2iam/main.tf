resource "helm_release" "kube2iam" {
  count = "${var.install_utilities  ? 1: 0}"

  name      = "kube2iam"
  chart     = "stable/kube2iam"
  namespace = "${var.tiller_namespace}"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}

resource "kubernetes_cluster_role_binding" "kube2iam" {
  count = "${var.install_utilities  ? 1: 0}"

  metadata {
    name = "kube2iam"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  # subject {
  #   kind      = "User"
  #   name      = "admin"
  #   api_group = "rbac.authorization.k8s.io"
  # }

  # subject {
  #   kind      = "ServiceAccount"
  #   name      = "kube2iam"
  #   namespace = "kube-system"
  #   api_group = ""
  # }

  # subject {
  #   kind      = "Group"
  #   name      = "system:masters"
  #   api_group = "rbac.authorization.k8s.io"
  # }
}
