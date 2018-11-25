module "k8s_dashboard" {
  source = "./modules/k8s-dashboard"

  install_utilities = "${var.install_utilities}"
  tiller_namespace  = "${var.tiller_namespace}"
}

module "metrics_server" {
  source = "./modules/metrics-server"

  tiller_namespace  = "${var.tiller_namespace}"
  install_utilities = "${var.install_utilities}"
}

module "fluentd_elasticsearch" {
  source = "./modules/fluentd-elasticsearch"

  tiller_namespace  = "${var.tiller_namespace}"
  install_utilities = "${var.install_utilities}"
}
