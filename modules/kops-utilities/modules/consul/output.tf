output "service_name" {
  value = "${helm_release.consul.*.name}"
}
