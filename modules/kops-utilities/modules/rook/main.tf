resource "helm_repository" "rook_beta" {
  name = "rook-beta"
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
