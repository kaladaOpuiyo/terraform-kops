# Create a source that waits for the cluster to be generated before 
# Executing this below var.depends_on??? 

resource "helm_release" "k8s_dashboard" {
  #   count = "${var.depends_on == "true" ? 1 : 0 }"
  name  = "k8s-dashboard"
  chart = "stable/kubernetes-dashboard"

  values = [
    "${file("${path.module}/values.yaml")}",
  ]
}
