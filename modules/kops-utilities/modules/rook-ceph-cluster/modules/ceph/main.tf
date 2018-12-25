module "cluster_resources" {
  source = "./modules/cluster-resources"

  rook_namespace = "${var.rook_namespace}"
}

module "cluster" {
  source = "./modules/cluster"

  namespace         = "${module.cluster_resources.rook_ceph_namespace}"
  ceph_cluster_name = "${module.cluster_resources.rook_ceph_namespace}"
}
