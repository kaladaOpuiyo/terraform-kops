variable "tiller_namespace" {
  description = "tiller_namespace"
}

variable "metrics_server_args" {
  type    = "list"
  default = ["--logtostderr", "--kubelet-preferred-address-types=InternalIP", "--kubelet-insecure-tls", "--v=1"]
}
