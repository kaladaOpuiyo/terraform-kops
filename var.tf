variable "acl" {}
variable "admin_access" {}
variable "ami" {}
variable "api_loadbalancer_type" {}
variable "associate_public_ip" {}
variable "authorization" {}
variable "availability_zone" {}
variable "bastion" {}
variable "cloud_labels" {}
variable "cloud" {}

variable "deploy_cluster" {
  default = "false"
}

variable "destroy_cluster" {
  default = "false"
}

variable "dns" {}

variable "dry_run" {
  default = "true"
}

variable "enable_dns_hostnames" {}
variable "enable_dns_support" {}
variable "encrypt_etcd_storage" {}
variable "env" {}
variable "force_destroy" {}
variable "instance_tenancy" {}

variable "kubelet_flags" {
  default = []
}

variable "kubernetes_version" {}

variable "master_count" {}
variable "master_size" {}
variable "master_volume_size" {}
variable "master_zone" {}
variable "max_nodes" {}
variable "min_nodes" {}
variable "network_cidr" {}
variable "networking" {}
variable "node_count" {}
variable "node_size" {}
variable "node_volume_size" {}
variable "out" {}
variable "output" {}
variable "region" {}

variable "route_tables" {
  default = []
}

variable "subnets" {
  default = {}
}

variable "target" {}
variable "topology" {}

variable "update_cluster" {
  default = "false"
}

variable "vpc_cidr" {}
variable "zones" {}
