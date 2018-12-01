resource "helm_repository" "vault" {
  name = "incubator"
  url  = "http://storage.googleapis.com/kubernetes-charts-incubator"
}

resource "helm_release" "vault" {
  name       = "vault"
  chart      = "incubator/vault"
  repository = "${helm_repository.vault.metadata.0.name}"

  namespace = "${var.tiller_namespace}"

  set {
    name  = "vault.dev"
    value = false
  }

  set {
    name  = "vault.config.storage.consul.address"
    value = "${element(var.depends_on, 0) }:8500"
  }

  set {
    name  = "vault.config.storage.consul.path"
    value = "vault"
  }

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}
