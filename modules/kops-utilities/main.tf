# Create a source that waits for the cluster to be generated before 
# Executing this below var.depends_on??? 

module "k8s_dashboard" {
  source = "./modules/k8-dashboard"
}

module "metrics_server" {
  source = "./metrics-server"
}
