resource "kubernetes_namespace" "istio" {
  metadata {
    # annotations {  #   name = "example-annotation"  # }

    labels {
      mylabel = "istio-system"
    }

    name = "istio-system"
  }
}

resource "helm_repository" "ibm" {
  name = "ibm"
  url  = "https://registry.bluemix.net/helm/ibm-charts"
}

resource "helm_repository" "ibm_charts" {
  name = "ibm-charts"
  url  = "https://registry.bluemix.net/helm/ibm-charts"
}

resource "helm_release" "istio" {
  name       = "istio"
  repository = "${helm_repository.ibm_charts.metadata.0.name}"
  chart      = "ibm-charts/ibm-istio"

  namespace = "istio-system"

  #   set {
  #     name  = "servicegraph.enabled"
  #     value = true
  #   }


  #   set {
  #     name  = "tracing.enabled"
  #     value = true
  #   }


  #   set {
  #     name  = "kiali.enabled"
  #     value = true
  #   }


  #   set {
  #     name  = "servicegraph.enabled"
  #     value = true
  #   }


  #   set {
  #     name  = "grafana.enabled"
  #     value = true
  #   }

  provisioner "local-exec" {
    command = "kubectl get customresourcedefinition  -n istio-system | grep 'istio'|awk '{print $1}'|xargs kubectl delete customresourcedefinition  -n istio-system"
    when    = "destroy"
  }
}
