module "cluster_autoscaler" {
  source = "./modules/cluster-autoscaler"

  kops_cluster_name      = "${var.kops_cluster_name}"
  kops_state_store       = "${var.kops_state_store}"
  kops_state_bucket_name = "${var.kops_state_bucket_name}"
  cluster_deployed       = "${var.cluster_deployed}"
}
