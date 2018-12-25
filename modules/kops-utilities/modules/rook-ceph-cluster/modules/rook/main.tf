resource "kubernetes_namespace" "rook" {
  metadata {
    annotations {
      name = "rook-ceph-system"
    }

    name = "rook-ceph-system"
  }
}

resource "helm_repository" "rook" {
  name = "rook-stable"
  url  = "https://charts.rook.io/stable"
}

resource "helm_release" "rook" {
  name       = "rook"
  chart      = "rook-stable/rook-ceph"
  repository = "${helm_repository.rook.metadata.0.name}"

  namespace = "${kubernetes_namespace.rook.metadata.0.name}"
}
