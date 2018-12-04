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

provider "helm" {
  debug           = "true"
  enable_tls      = "false"
  install_tiller  = "false"
  namespace       = "kube-system"
  service_account = "tiller"

  kubernetes {}
}

locals {
  cluster_bucket = "tf-state-test-kalada-opuiyo"
  cluster_key    = "env:/${terraform.workspace}/kops-cluster"
  cluster_region = "us-east-1"

  #Used to retrive the dommain certificate info
  domain_name            = "api.${terraform.workspace}.kaladaopuiyo.com"
  keypair_name           = "${terraform.workspace}_cluster_kalada_opuiyo.com"
  kops_cluster_name      = "${terraform.workspace}.kaladaopuiyo.com"
  kops_state_bucket_name = "k8s.kaladaopuiyo.com"
}

module "kops_cluster" {
  source = "./modules/kops-cluster"

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
  cluster_bucket         = "${local.cluster_bucket}"
  cluster_key            = "${local.cluster_key}"
  cluster_region         = "${local.cluster_region}"
  deploy_cluster         = "${var.deploy_cluster}"
  destroy_cluster        = "${var.destroy_cluster}"
  dns                    = "${var.dns}"
  domain_name            = "${local.domain_name}"
  dry_run                = "${var.dry_run}"
  enable_dns_hostnames   = "${var.enable_dns_hostnames}"
  enable_dns_support     = "${var.enable_dns_support}"
  encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
  env                    = "${var.env}"
  force_destroy          = "${var.force_destroy}"
  instance_tenancy       = "${var.instance_tenancy}"
  keypair_name           = "${local.keypair_name}"
  kops_cluster_name      = "${local.kops_cluster_name}"
  kops_state_bucket_name = "${local.kops_state_bucket_name}"
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
  region                 = "${var.region}"
  route_tables           = "${var.route_tables}"
  subnets                = "${var.subnets}"
  target                 = "${var.target}"
  topology               = "${var.topology}"
  update_cluster         = "${var.update_cluster}"
  vpc_cidr               = "${var.vpc_cidr}"
  zones                  = "${var.zones}"
}

module "kops_iam" {
  source = "./modules/kops-iam"
}

module "kops_utilities" {
  source = "./modules/kops-utilities"

  kops_cluster_name = "${terraform.workspace}.${local.kops_cluster_name}"
  tiller_namespace  = "kube-system"

  depends_on = [
    "${module.kops_cluster.cluster_exist}",
  ]
}
