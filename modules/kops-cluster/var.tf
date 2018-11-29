variable "env" {
  description = "env"
}

variable "region" {
  description = "region"
}

variable "force_destroy" {
  description = "force_destroy"
}

variable "acl" {
  description = "acl"
}

variable "kops_state_bucket_name" {
  description = "kops_state_bucket_name"
}

variable "master_size" {
  description = "master_size"
}

variable "master_zone" {
  description = "master_zone"
}

variable "master_count" {
  description = "master_count"
}

variable "master_volume_size" {
  description = "master_volume_size"
}

variable "node_size" {
  description = "node_size"
}

variable "node_count" {
  description = "node_count"
}

variable "zones" {
  description = "zones"
}

variable "networking" {
  description = "networking"
}

variable "network_cidr" {
  description = "network_cidr"
}

variable "topology" {
  description = "topology"
}

variable "api_ssl_certificate" {
  description = "api_ssl_certificate"
  default     = ""
}

variable "api_loadbalancer_type" {
  description = "api_loadbalancer_type"
}

variable "kops_attach_policy" {
  description = "kops_attach_policy"

  default = [
    "AmazonEC2FullAccess",
    "AmazonRoute53FullAccess",
    "AmazonS3FullAccess",
    "IAMFullAccess",
    "AmazonVPCFullAccess",
  ]
}

variable "target" {
  description = "target"
}

variable "output" {
  description = "output"
}

variable "kubernetes_version" {
  description = "kubernetes_version"
}

variable "associate_public_ip" {
  description = "associate_public_ip"
}

variable "dns" {
  description = "dns"
}

variable "cloud" {
  description = "cloud"
}

variable "admin_access" {
  description = "admin_access"
}

variable "cloud_labels" {
  description = "cloud_labels"
}

variable "encrypt_etcd_storage" {
  description = "encrypt_etcd_storage"
}

variable "authorization" {
  description = "authorization"
}

variable "dry_run" {
  description = "dry_run"
}

variable "node_volume_size" {
  description = "node_volume_size"
}

variable "bastion" {
  description = "bastion"
}

variable "kops_cluster_name" {
  description = "kops_cluster_name"
}

variable "update_cluster" {
  description = "update_cluster"
}

variable "keypair_name" {
  description = "keypair_name"
}

variable "ami" {
  description = "ami"
}

variable "domain_name" {
  description = "domain_name"
}

variable "out" {
  description = "out"
}

variable "vpc_cidr" {
  description = "vpc_cidr"
}

variable "enable_dns_support" {
  description = "enable_dns_support"
}

variable "enable_dns_hostnames" {
  description = "enable_dns_hostnames"
}

variable "instance_tenancy" {
  description = "instance_tenancy "
}

variable "subnets" {
  description = "subnets"
  default     = {}
}

variable "route_tables" {
  default = []
}

variable "availability_zone" {
  description = "availability_zone"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "cluster_bucket" {
  description = "cluster_bucket"
}

variable "cluster_key" {
  description = "cluster_key"
}

variable "cluster_region" {
  description = "cluster_region"
}

variable "deploy_cluster" {
  description = "deploy_cluster"
}
