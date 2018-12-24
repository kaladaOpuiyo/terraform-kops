variable "tiller_namespace" {
  description = "tiller_namespace"
}

variable "metrics_server_args" {
  type    = "list"
  default = ["--logtostderr", "--kubelet-preferred-address-types=InternalDNS,InternalIP,ExternalDNS,ExternalIP,Hostname", "--kubelet-insecure-tls", "--v=1"]
}
