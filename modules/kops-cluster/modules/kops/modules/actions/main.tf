module "destroy" {
  source = "./modules/destroy"

  destroy_cluster   = "${var.destroy_cluster}"
  kops_cluster_name = "${var.kops_cluster_name}"
  kops_state_store  = "${var.kops_state_store}"
  out               = "${var.out}"
}

module "tf" {
  source = "./modules/tf"

  admin_access           = "${var.admin_access}"
  ami                    = "${var.ami}"
  api_loadbalancer_type  = "${var.api_loadbalancer_type}"
  associate_public_ip    = "${var.associate_public_ip}"
  authorization          = "${var.authorization}"
  bastion                = "${var.bastion}"
  cloud                  = "${var.cloud}"
  cloud_labels           = "${var.cloud_labels}"
  cluster_bucket         = "${var.cluster_bucket}"
  cluster_key            = "${var.cluster_key}"
  cluster_region         = "${var.cluster_region}"
  deploy_cluster         = "${var.deploy_cluster}"
  dns                    = "${var.dns}"
  domain_cert_arn        = "${var.domain_cert_arn}"
  dry_run                = "${var.dry_run}"
  encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
  kops_cluster_name      = "${var.kops_cluster_name}"
  kops_state_bucket_name = "${var.kops_state_bucket_name}"
  kops_state_store       = "${var.kops_state_store}"
  kubernetes_version     = "${var.kubernetes_version}"
  master_count           = "${var.master_count}"
  master_size            = "${var.master_size}"
  master_volume_size     = "${var.master_volume_size}"
  master_zone            = "${var.master_zone}"
  need_update            = "${var.need_update}"
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

module "update" {
  source = "./modules/update"

  admin_access           = "${var.admin_access}"
  ami                    = "${var.ami}"
  api_loadbalancer_type  = "${var.api_loadbalancer_type}"
  associate_public_ip    = "${var.associate_public_ip}"
  authorization          = "${var.authorization}"
  bastion                = "${var.bastion}"
  cloud                  = "${var.cloud}"
  cloud_labels           = "${var.cloud_labels}"
  deploy_cluster         = "${var.deploy_cluster}"
  domain_cert_arn        = "${var.domain_cert_arn}"
  dns                    = "${var.dns}"
  dry_run                = "${var.dry_run}"
  encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
  kops_cluster_name      = "${var.kops_cluster_name}"
  kops_state_bucket_name = "${var.kops_state_bucket_name}"
  kops_state_store       = "${var.kops_state_store}"
  kubernetes_version     = "${var.kubernetes_version}"
  master_count           = "${var.master_count}"
  master_size            = "${var.master_size}"
  master_volume_size     = "${var.master_volume_size}"
  master_zone            = "${var.master_zone}"
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

module "yaml" {
  source = "./modules/yaml"

  admin_access           = "${var.admin_access}"
  ami                    = "${var.ami}"
  api_loadbalancer_type  = "${var.api_loadbalancer_type}"
  associate_public_ip    = "${var.associate_public_ip}"
  authorization          = "${var.authorization}"
  bastion                = "${var.bastion}"
  cloud                  = "${var.cloud}"
  cloud_labels           = "${var.cloud_labels}"
  cluster_deployed       = "${var.cluster_deployed}"
  deploy_cluster         = "${var.deploy_cluster}"
  domain_cert_arn        = "${var.domain_cert_arn}"
  dns                    = "${var.dns}"
  dry_run                = "${var.dry_run}"
  encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
  kops_cluster_name      = "${var.kops_cluster_name}"
  kops_state_bucket_name = "${var.kops_state_bucket_name}"
  kops_state_store       = "${var.kops_state_store}"
  kubernetes_version     = "${var.kubernetes_version}"
  master_count           = "${var.master_count}"
  master_size            = "${var.master_size}"
  master_volume_size     = "${var.master_volume_size}"
  master_zone            = "${var.master_zone}"
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
