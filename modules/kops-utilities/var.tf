variable "kops_cluster_name" {
  description = "kops_cluster_name"
}

variable "install_utilities" {
  description = "install_utilities"
}

variable "depends_on" {
  description = "depends_on"
  default     = []
}

variable "tiller_namespace" {
  description = "tiller_namespace"
}
