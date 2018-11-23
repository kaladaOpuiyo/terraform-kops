output "cluster_exist" {
  value = "${data.external.check_if_cluster_exist.result}"
}
