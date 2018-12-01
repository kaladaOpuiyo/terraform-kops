.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help


init: ## Init terraform
	terraform init

create_cluster: ## Creates cluster, sets -var 'dry_run=false' , -var 'deploy_cluster=true' ,  -var 'update_cluster=false'
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
	 -var 'update_cluster=false' \
	 -var 'destroy_cluster=false'

create_terraform: ## Creates terraform auto-genrated code for cluster , sets -var 'dry_run=false' , -var 'deploy_cluster=false' ,  -var 'update_cluster=false'
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=false' \
	 -var 'update_cluster=false' \
	 -var 'destroy_cluster=false'

create_utilities: ## Installs helm cluster utilities charts, sets -var 'dry_run=true' , -var 'deploy_cluster=true' ,-var 'update_cluster=false'
	terraform apply -target=module.kops_utilities -auto-approve

create_yaml: ## Creates terraform auto-genrated code for cluster , sets -var 'dry_run=true' , -var 'deploy_cluster=false' ,  -var 'update_cluster=false'
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=true' \
  	 -var 'deploy_cluster=false' \
	 -var 'update_cluster=false' \
	 -var 'destroy_cluster=false'

destroy_cluster: ## Destroys cluster
	terraform destroy -target=module.kops_cluster \
     -var 'destroy_cluster=true'

destroy_utilities: ## Uninstalls helm cluster utilities charts
	terraform destroy -target=module.kops_utilities

plan_cluster: ## Run a plan against current cluster settings does not plan auto genetrated kops code. May be future addition
	terraform plan -target=module.kops_cluster

plan_utilities: ## Run a plan on the kops- utilities module
	terraform plan -target=module.kops_utilities

update_cluster: ## Run a rolling update against the cluster
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
 	 -var 'update_cluster=true' \
	 -var 'destroy_cluster=false'





