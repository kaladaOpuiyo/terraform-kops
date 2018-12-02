variable "acl" {}
variable "admin_access" {}
variable "ami" {}
variable "api_loadbalancer_type" {}

variable "api_ssl_certificate" {
  default = ""
}

variable "associate_public_ip" {}
variable "authorization" {}
variable "availability_zone" {}
variable "bastion" {}
variable "cloud_labels" {}
variable "cloud" {}
variable "cluster_bucket" {}
variable "cluster_key" {}
variable "cluster_region" {}
variable "destroy_cluster" {}

variable "deploy_cluster" {}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "dns" {}
variable "domain_name" {}
variable "dry_run" {}
variable "enable_dns_hostnames" {}
variable "enable_dns_support" {}
variable "encrypt_etcd_storage" {}
variable "env" {}
variable "force_destroy" {}
variable "instance_tenancy" {}
variable "keypair_name" {}

variable "kops_cluster_name" {}
variable "kops_state_bucket_name" {}
variable "kubernetes_version" {}
variable "master_count" {}
variable "master_size" {}
variable "master_volume_size" {}
variable "master_zone" {}
variable "network_cidr" {}
variable "networking" {}
variable "node_count" {}
variable "node_size" {}
variable "node_volume_size" {}
variable "out" {}
variable "output" {}
variable "region" {}
variable "target" {}
variable "topology" {}
variable "update_cluster" {}
variable "vpc_cidr" {}
variable "zones" {}

variable "subnets" {
  default = {}
}

variable "route_tables" {
  default = []
}
