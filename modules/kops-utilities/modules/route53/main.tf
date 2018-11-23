resource "helm_release" "route53" {
  name  = "k8s-dashboard"
  chart = "stable/metrics-server"

  values = [
    "${file("${path.module}/chart/values.yaml")}",
  ]
}

# helm repo rm cloudposse-incubator 2>/dev/null
# $ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator/
# helm install --namespace kube-system --name route53 cloudposse-incubator/route53-kubernetes

