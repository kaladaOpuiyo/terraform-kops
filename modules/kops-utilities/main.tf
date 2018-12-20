module "k8s_dashboard" {
  source = "./modules/k8s-dashboard"

  tiller_namespace = "${var.tiller_namespace}"
}

module "metrics_server" {
  source = "./modules/metrics-server"

  tiller_namespace = "${var.tiller_namespace}"
}

module "fluentd_elasticsearch" {
  source = "./modules/fluentd-elasticsearch"

  tiller_namespace = "${var.tiller_namespace}"
}

module "consul" {
  source = "./modules/consul"

  tiller_namespace = "${var.tiller_namespace}"
}

module "istio" {
  source = "./modules/istio"

  helm_repository_url    = "${var.istio_helm_repository_url}"
  istio_install_test_app = "${var.istio_install_test_app}"
  istio_repo             = "${var.istio_repo}"
  istio_version          = "${var.istio_version}"
}

module "vault" {
  source = "./modules/vault"

  tiller_namespace = "${var.tiller_namespace}"

  depends_on = ["${module.consul.service_name}"]
}

module "rook" {
  source = "./modules/rook"

  tiller_namespace = "${var.tiller_namespace}"
}
