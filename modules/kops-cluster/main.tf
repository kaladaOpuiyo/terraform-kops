module "certs" {
  source = "./modules/certs"

  update_cluster = "${var.update_cluster}"
  domain_name    = "${var.domain_name}"
  keypair_name   = "${var.keypair_name}"
}

module "iam" {
  source = "./modules/iam"

  kops_attach_policy = "${var.kops_attach_policy}"
}

module "kops" {
  source = "./modules/kops"

  acl                    = "${var.acl}"
  admin_access           = "${var.admin_access}"
  ami                    = "${var.ami}"
  api_loadbalancer_type  = "${var.api_loadbalancer_type}"
  associate_public_ip    = "${var.associate_public_ip}"
  authorization          = "${var.authorization}"
  availability_zone      = "${var.availability_zone}"
  bastion                = "${var.bastion}"
  cloud                  = "${var.cloud}"
  cloud_labels           = "${var.cloud_labels}"
  cluster_bucket         = "${var.cluster_bucket}"
  cluster_key            = "${var.cluster_key}"
  cluster_region         = "${var.cluster_region}"
  destroy_cluster        = "${var.destroy_cluster}"
  deploy_cluster         = "${var.deploy_cluster}"
  dns                    = "${var.dns}"
  domain_cert_arn        = "${module.certs.domain_cert_arn}"
  domain_name            = "${var.domain_name}"
  dry_run                = "${var.dry_run}"
  enable_dns_hostnames   = "${var.enable_dns_hostnames}"
  enable_dns_support     = "${var.enable_dns_support}"
  encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
  env                    = "${var.env}"
  force_destroy          = "${var.force_destroy}"
  instance_tenancy       = "${var.instance_tenancy}"
  keypair_name           = "${var.keypair_name}"
  kops_cluster_name      = "${var.kops_cluster_name}"
  kops_state_bucket_name = "${var.kops_state_bucket_name}"
  kops_state_store       = "${module.s3.kops_state_store}"
  kubernetes_version     = "${var.kubernetes_version}"
  master_count           = "${var.master_count}"
  master_size            = "${var.master_size}"
  master_volume_size     = "${var.master_volume_size}"
  master_zone            = "${var.master_zone}"
  network_cidr           = "${module.networking.network_cidr}"
  networking             = "${var.networking}"
  node_count             = "${var.node_count}"
  node_size              = "${var.node_size}"
  node_volume_size       = "${var.node_volume_size}"
  out                    = "${var.out}"
  output                 = "${var.output}"
  region                 = "${var.region}"
  route_tables           = "${var.route_tables}"
  ssh_private_key        = "${module.certs.private_key}"
  ssh_public_key         = "${module.certs.public_key}"
  subnets                = "${var.subnets}"
  target                 = "${var.target}"
  topology               = "${var.topology}"
  update_cluster         = "${var.update_cluster}"
  vpc_cidr               = "${var.vpc_cidr}"
  vpc_id                 = "${module.networking.vpc_id}"
  zones                  = "${var.zones}"
}

module "networking" {
  source = "./modules/networking"

  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  env                  = "${terraform.workspace}"
  instance_tenancy     = "${var.instance_tenancy}"
  kops_cluster_name    = "${var.kops_cluster_name}"
  vpc_cidr             = "${var.vpc_cidr}"
}

module "s3" {
  source = "./modules/s3"

  acl                    = "${var.acl}"
  env                    = "${terraform.workspace}"
  force_destroy          = "${var.force_destroy}"
  kops_state_bucket_name = "${var.kops_state_bucket_name}"
  region                 = "${var.region}"
}
