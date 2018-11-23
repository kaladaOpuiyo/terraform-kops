provider "aws" {
  region  = "us-east-1"
  version = "~> 1.45"
}

terraform {
  backend "s3" {
    bucket = "tf-state-test-kalada-opuiyo"
    key    = "kops-cluster/kops_cluster.tfstate"
    region = "us-east-1"
  }
}

locals {
  # update_cluster should always be false for now. 
  # Kops does not provided a simple way to programmatically update a cluster 
  # still working on this ;) DOES NOTHING 
  update_cluster = "false"

  dry_run                = "false"
  keypair_name           = "cluster_kalada_opuiyo.com"
  kops_cluster_name      = "kaladaopuiyo.com"
  domain_name            = "www.kaladaopuiyo.com"
  kops_state_bucket_name = "k8s.kaladaopuiyo.com"
  cluster_region         = "us-east-1"
  cluster_key            = "env:/${terraform.workspace}/kops-cluster"
  cluster_bucket         = "tf-state-test-kalada-opuiyo"

  install_utilities = true

  deployCluster = "true"
}

module "kops_cluster" {
  source = "./modules/kops-cluster"

  ami                    = "${var.ami}"
  kops_cluster_name      = "${terraform.workspace}.${local.kops_cluster_name}"
  domain_name            = "${local.domain_name}"
  kops_state_bucket_name = "${local.kops_state_bucket_name}"
  region                 = "${var.region}"
  master_size            = "${var.master_size}"
  master_zone            = "${var.master_zone}"
  master_count           = "${var.master_count}"
  master_volume_size     = "${var.master_volume_size}"
  node_size              = "${var.node_size}"
  node_count             = "${var.node_count}"
  zones                  = "${var.zones}"
  network_cidr           = "${var.network_cidr}"
  networking             = "${var.networking}"
  keypair_name           = "${local.keypair_name}"
  topology               = "${var.topology}"
  api_loadbalancer_type  = "${var.api_loadbalancer_type}"
  env                    = "${var.env}"
  force_destroy          = "${var.force_destroy}"
  acl                    = "${var.acl}"
  associate_public_ip    = "${var.associate_public_ip}"
  encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
  dry_run                = "${local.dry_run}"
  dns                    = "${var.dns}"
  cloud                  = "${var.cloud}"
  output                 = "${var.output}"
  out                    = "${var.out}"
  admin_access           = "${var.admin_access}"
  target                 = "${var.target}"
  kubernetes_version     = "${var.kubernetes_version}"
  node_volume_size       = "${var.node_volume_size}"
  cloud_labels           = "${var.cloud_labels}"
  authorization          = "${var.authorization}"
  bastion                = "${var.bastion}"
  update_cluster         = "${local.update_cluster}"
  cluster_bucket         = "${local.cluster_bucket}"
  cluster_key            = "${local.cluster_key}"
  cluster_region         = "${local.cluster_region}"
  enable_dns_support     = "${var.enable_dns_support}"
  enable_dns_hostnames   = "${var.enable_dns_hostnames}"
  instance_tenancy       = "${var.instance_tenancy}"
  availability_zone      = "${var.availability_zone}"
  route_tables           = "${var.route_tables}"
  vpc_cidr               = "${var.vpc_cidr}"
  subnets                = "${var.subnets}"
  deployCluster          = "${local.deployCluster}"
}

# module "kops_utilities" {
#   source = "./modules/kops-utilities"


#   kops_cluster_name = "${terraform.workspace}.${local.kops_cluster_name}"
#   install_utilities = "${local.install_utilities}"


#   depends_on = [
#     "${module.kops_cluster.cluster_exist}",
#   ]
# }

