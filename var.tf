variable "region" {}
variable "master_size" {}
variable "master_zone" {}
variable "master_count" {}
variable "master_volume_size" {}
variable "node_size" {}
variable "node_count" {}
variable "zones" {}
variable "networking" {}
variable "network_cidr" {}
variable "topology" {}
variable "api_loadbalancer_type" {}
variable "target" {}
variable "acl" {}
variable "authorization" {}
variable "encrypt_etcd_storage" {}
variable "kubernetes_version" {}
variable "cloud_labels" {}
variable "dns" {}
variable "node_volume_size" {}
variable "output" {}
variable "env" {}
variable "associate_public_ip" {}
variable "force_destroy" {}
variable "admin_access" {}
variable "cloud" {}
variable "bastion" {}
variable "out" {}

variable "ami" {}
variable "enable_dns_support" {}
variable "enable_dns_hostnames" {}
variable "instance_tenancy" {}
variable "vpc_cidr" {}
variable "availability_zone" {}

variable "subnets" {
  default = {}
}

variable "route_tables" {
  default = []
}