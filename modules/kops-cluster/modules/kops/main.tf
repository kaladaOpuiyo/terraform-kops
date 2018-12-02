module "kops_actions" {
  source = "./modules/kops-actions"

  admin_access           = "${var.admin_access}"
  api_loadbalancer_type  = "${var.api_loadbalancer_type}"
  associate_public_ip    = "${var.associate_public_ip}"
  authorization          = "${var.authorization}"
  bastion                = "${var.bastion}"
  cloud                  = "${var.cloud}"
  cloud_labels           = "${var.cloud_labels}"
  cluster_bucket         = "${var.cluster_bucket}"
  cluster_deployed       = "${module.checks.cluster_deployed}"
  cluster_region         = "${var.cluster_region}"
  deploy_cluster         = "${var.deploy_cluster}"
  destroy_cluster        = "${var.destroy_cluster}"
  dns                    = "${var.dns}"
  cluster_key            = "${var.cluster_key}"
  domain_cert_arn        = "${var.domain_cert_arn}"
  dry_run                = "${var.dry_run}"
  encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
  ami                    = "${var.ami}"
  force_destroy          = "${var.force_destroy}"
  enable_dns_hostnames   = "${var.enable_dns_hostnames}"
  kops_cluster_name      = "${var.kops_cluster_name}"
  kops_state_bucket_name = "${var.kops_state_bucket_name}"
  kops_state_store       = "${var.kops_state_store}"
  kubernetes_version     = "${var.kubernetes_version}"
  master_count           = "${var.master_count}"
  master_size            = "${var.master_size}"
  master_volume_size     = "${var.master_volume_size}"
  master_zone            = "${var.master_zone}"
  need_update            = "${module.checks.cluster_rolling_update}"
  network_cidr           = "${var.network_cidr}"
  networking             = "${var.networking}"
  node_count             = "${var.node_count}"
  node_size              = "${var.node_size}"
  node_volume_size       = "${var.node_volume_size}"
  out                    = "${var.out}"
  output                 = "${var.output}"
  ssh_private_key        = "${var.ssh_private_key}"
  ssh_public_key         = "${var.ssh_public_key}"
  target                 = "${var.target}"
  topology               = "${var.topology}"
  update_cluster         = "${var.update_cluster}"
  vpc_id                 = "${var.vpc_id}"
  zones                  = "${var.zones}"
}

module "checks" {
  source = "./modules/checks"

  kops_cluster_name      = "${var.kops_cluster_name}"
  kops_state_store       = "${var.kops_state_bucket_name}"
  kops_state_bucket_name = "${var.kops_state_bucket_name}"
}
