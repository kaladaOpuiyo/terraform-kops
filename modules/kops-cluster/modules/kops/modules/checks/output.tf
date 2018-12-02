output "cluster_exist" {
  value = "${data.external.check_if_cluster_exist.result}"
}

output "cluster_deployed" {
  value = "${data.external.check_if_cluster_deployed.result["CLUSTER_DEPLOYED"]?"true":"false"}"
}

output "cluster_rolling_update" {
  value = "${data.external.check_if_cluster_needs_rolling_update.result["ROLLING_UPDATE"]?"true":"false"}"
}
