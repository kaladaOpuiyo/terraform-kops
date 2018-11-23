module "k8s_dashboard" {
  source = "./modules/k8s-dashboard"

  install_utilities = "${var.install_utilities}"
}

module "metrics_server" {
  source = "./modules/metrics-server"

  install_utilities = "${var.install_utilities}"
}
