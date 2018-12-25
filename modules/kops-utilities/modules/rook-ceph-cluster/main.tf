module "ceph" {
  source = "./modules/ceph"

  rook_namespace = "${module.rook.rook_namespace}"
}

module "rook" {
  source = "./modules/rook"

  tiller_namespace = "${var.tiller_namespace}"
}
