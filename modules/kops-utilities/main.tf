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

module "consul" {
  source = "./modules/consul"

  tiller_namespace  = "${var.tiller_namespace}"
  install_utilities = "${var.install_utilities}"
}

module "vault" {
  source = "./modules/vault"

  tiller_namespace  = "${var.tiller_namespace}"
  install_utilities = "${var.install_utilities}"

  depends_on = ["${module.consul.service_name}"]
}

module "rook" {
  source = "./modules/rook"

  tiller_namespace  = "${var.tiller_namespace}"
  install_utilities = "${var.install_utilities}"
}
