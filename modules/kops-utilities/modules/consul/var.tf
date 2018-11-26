variable "install_utilities" {
  description = "install_utilities"
}

variable "tiller_namespace" {
  description = "tiller_namespace"
}

variable "consul_binary_url" {
  description = "consul_binary_url"
  default     = "https://codeload.github.com/hashicorp/consul-helm/tar.gz/v0.3.0"
}
