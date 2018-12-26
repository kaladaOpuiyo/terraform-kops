variable "admin_access" {}
variable "ami" {}
variable "api_loadbalancer_type" {}
variable "associate_public_ip" {}
variable "authorization" {}
variable "bastion" {}
variable "cloud_labels" {}
variable "cloud" {}
variable "cluster_bucket" {}
variable "cluster_deployed" {}

variable "cluster_key" {}
variable "cluster_region" {}
variable "deploy_cluster" {}
variable "dns" {}
variable "domain_cert_arn" {}
variable "dry_run" {}
variable "encrypt_etcd_storage" {}
variable "kops_cluster_name" {}
variable "kops_state_bucket_name" {}
variable "kops_state_store" {}

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
variable "need_update" {}
variable "network_cidr" {}
variable "networking" {}
variable "node_count" {}
variable "node_size" {}
variable "node_volume_size" {}
variable "out" {}
variable "output" {}
variable "ssh_private_key" {}
variable "ssh_public_key" {}
variable "target" {}
variable "topology" {}
variable "update_cluster" {}
variable "vpc_id" {}
variable "zones" {}
