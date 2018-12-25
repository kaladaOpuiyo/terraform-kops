output "rook_namespace" {
  value = "${helm_release.rook.metadata.0.namespace}"
}
