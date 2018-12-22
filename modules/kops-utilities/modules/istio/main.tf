locals {
  istio_path = "${path.root}/tmp/istio-${var.istio_version}"
}

resource "kubernetes_namespace" "istio" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_repository" "istio" {
  name = "istio.io"
  url  = "${var.helm_repository_url}"
}

resource "null_resource" "istio_repo" {
  provisioner "local-exec" {
    command = "cd ${path.root}/tmp && curl -L ${var.istio_repo} | sh - && sleep 30"
  }
}

resource "helm_release" "istio" {
  name      = "istio"
  namespace = "istio-system"

  chart = "${local.istio_path}/install/kubernetes/helm/istio"

  set {
    name  = "servicegraph.enabled"
    value = true
  }

  set {
    name  = "grafana.enabled"
    value = true
  }

  provisioner "local-exec" {
    command = "kubectl get customresourcedefinition  -n istio-system | grep 'istio'|awk '{print $1}'|xargs kubectl delete customresourcedefinition  -n istio-system"
    when    = "destroy"
  }

  depends_on = ["kubernetes_namespace.istio"]

  # set {
  #   name  = "tracing.enabled"
  #   value = true
  # }

  # set {
  #   name  = "kiali.enabled"
  #   value = true
  # }
}

resource "null_resource" "instio_injection" {
  count = "${var.istio_install_test_app ? 1 : 0}"

  provisioner "local-exec" {
    command = "kubectl label namespace default istio-injection=enabled"
  }

  provisioner "local-exec" {
    command = "kubectl label namespace default istio-injection-"
    when    = "destroy"
  }

  depends_on = ["helm_release.istio"]
}

resource "null_resource" "istio_test_app" {
  count = "${var.istio_install_test_app ? 1 : 0}"

  provisioner "local-exec" {
    command = "kubectl apply -f ${local.istio_path}/samples/bookinfo/platform/kube/bookinfo.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local.istio_path}/samples/bookinfo/networking/bookinfo-gateway.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local.istio_path}/samples/bookinfo/networking/destination-rule-all.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local.istio_path}/samples/bookinfo/networking/destination-rule-all-mtls.yaml"
  }

  provisioner "local-exec" {
    command = "export PATH=$PATH:${local.istio_path}/bin/ && ${local.istio_path}/samples/bookinfo/platform/kube/cleanup.sh"
    when    = "destroy"
  }

  depends_on = ["null_resource.instio_injection"]
}
