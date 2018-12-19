locals {
  helm_repository_url = "https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts"
  istio_repo          = "https://git.io/getLatestIstio"

  istio_version = "1.0.5"
}

resource "kubernetes_namespace" "istio" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_repository" "istio" {
  name = "istio.io"
  url  = "${local.helm_repository_url}"
}

resource "null_resource" "istio_repo" {
  provisioner "local-exec" {
    command = "cd ${path.root}/tmp && curl -L ${local.istio_repo} | sh -"
  }
}

resource "helm_release" "istio" {
  name      = "istio"
  namespace = "istio-system"

  chart = "${path.root}/tmp/istio-${local.istio_version}/install/kubernetes/helm/istio"

  # set {
  #   name  = "servicegraph.enabled"
  #   value = true
  # }


  # set {
  #   name  = "tracing.enabled"
  #   value = true
  # }


  # set {
  #   name  = "kiali.enabled"
  #   value = true
  # }


  # set {
  #   name  = "servicegraph.enabled"
  #   value = true
  # }


  # set {
  #   name  = "grafana.enabled"
  #   value = true
  # }

  provisioner "local-exec" {
    command = "kubectl get customresourcedefinition  -n istio-system | grep 'istio'|awk '{print $1}'|xargs kubectl delete customresourcedefinition  -n istio-system"
    when    = "destroy"
  }
}
