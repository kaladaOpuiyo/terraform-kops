output "cluster_exist" {
  value = "${module.kops.cluster_exist}"
}

output "cluster_deployed" {
  value = "${module.kops.cluster_deployed}"
}
