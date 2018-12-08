.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help


all: init create_user create_cluster create_addons create_utilities ## Create all resources
destroy_all: init destroy_utilities destroy_addons destroy_cluster destroy_user    ## Destroy all resources

init: ## Init terraform
	terraform init


create_user: ## Creates kops iam user should be executed after init
	terraform apply -target=module.kops_iam -auto-approve

create_cluster: ## Creates cluster, sets -var 'dry_run=false' , -var 'deploy_cluster=true' ,  -var 'update_cluster=false'.Specific utility, module=name

ifdef module
	terraform apply -target=module.kops_cluster.module.$(module) -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
	 -var 'update_cluster=false' \
	 -var 'destroy_cluster=false'
else
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
	 -var 'update_cluster=false' \
	 -var 'destroy_cluster=false'
endif

create_terraform: ## Creates terraform auto-genrated code for cluster , sets -var 'dry_run=false' , -var 'deploy_cluster=false' ,  -var 'update_cluster=false'
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=false' \
	 -var 'update_cluster=false' \
	 -var 'destroy_cluster=false'

create_utilities: ## Installs helm cluster utilities charts. Specific utility, module=name

ifdef module
	terraform apply -target=module.kops_utilities.module.$(module) -auto-approve
else
	terraform apply -target=module.kops_utilities -auto-approve
endif

create_addons: ## Installs addons. Specific addon, module=name

ifdef module
	terraform apply -target=module.kops_addons.module.$(module) -auto-approve
else
	terraform apply -target=module.kops_addons -auto-approve
endif

create_yaml: ## Creates terraform auto-genrated code for cluster , sets -var 'dry_run=true' , -var 'deploy_cluster=false' ,  -var 'update_cluster=false'
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=true' \
  	 -var 'deploy_cluster=false' \
	 -var 'update_cluster=false' \
	 -var 'destroy_cluster=false'

destroy_cluster: ## Destroys cluster,specific utility, module=name

ifdef module
	terraform destroy -target=module.kops_cluster.module.$(module)
else
	terraform destroy -target=module.kops_cluster
endif

destroy_user: ## Removes kops user and associated resources from iam
	terraform destroy -target=module.kops_iam

destroy_utilities: ## Destroys addons resources, does not in most case effect cluster settings.. Specific addon, module=name

ifdef module
	terraform destroy -target=module.kops_utilities.module.$(module)
else
	terraform destroy -target=module.kops_utilities
endif

destroy_addons: ## Uninstalls helm cluster utilities charts. Specific utility, module=name

ifdef module
	terraform destroy -target=module.kops_addons.module.$(module)
else
	terraform destroy -target=module.kops_addons
endif

plan_cluster: ## Run a plan against current cluster settings does not plan auto genetrated kops code. May be future addition

ifdef module
	terraform plan -target=module.kops_cluster.module.$(module)
else
	terraform plan -target=module.kops_cluster
endif

plan_addons: ## Run a plan on the kops_utilities module. Specific utility, module=name

ifdef module
	terraform plan -target=module.kops_addons.module.$(module)
else
	terraform plan -target=module.kops_addons
endif


plan_utilities: ## Run a plan on the kops_utilities module. Specific utility, module=name

ifdef module
	terraform plan -target=module.kops_utilities.module.$(module)
else
	terraform plan -target=module.kops_utilities
endif


plan_user: ## Run a plan on the kops_iam module
	terraform plan -target=module.kops_iam

update_cluster: ## Run a rolling update against the cluster
ifdef module
	terraform apply -target=module.kops_cluster.module.$(module) -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
 	 -var 'update_cluster=true' \
	 -var 'destroy_cluster=false'
else
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
 	 -var 'update_cluster=true' \
	 -var 'destroy_cluster=false'
endif

update_cluster_plan: ## Run a rolling update against the cluster. Only kops_tf and kops_update local_files should be recreated when run
	terraform plan -target=module.kops_cluster \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
 	 -var 'update_cluster=true' \
	 -var 'destroy_cluster=false'






