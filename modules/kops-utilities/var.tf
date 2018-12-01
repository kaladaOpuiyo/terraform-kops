variable "kops_cluster_name" {
  description = "kops_cluster_name"
}

variable "depends_on" {
  description = "depends_on"
  default     = []
}

variable "tiller_namespace" {
  description = "tiller_namespace"
}
