variable "depends_on" {
  description = "depends_on"
  default     = []
}

variable "kops_cluster_name" {
  description = "kops_cluster_name"
}

variable "istio_helm_repository_url" {
  default = "https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts"
}

variable "istio_install_test_app" {
  default = "false"
}

variable "istio_repo" {
  default = "https://git.io/getLatestIstio"
}

variable "istio_version" {
  default = "1.0.5"
}

variable "max_nodes" {}
variable "min_nodes" {}

variable "tiller_namespace" {
  description = "tiller_namespace"
  default     = "kube-system"
}

variable "cluster_deployed" {}
variable "kops_state_bucket_name" {}
