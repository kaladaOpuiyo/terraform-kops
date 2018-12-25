output "rook_ceph_namespace" {
  value = "${kubernetes_namespace.rook_ceph.metadata.0.name}"
}
