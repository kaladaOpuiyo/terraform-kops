.PHONY:


init:
	terraform init

create_cluster:
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
	 -var 'update_cluster=false'

create_terraform:
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=false' \
	 -var 'update_cluster=false'

create_utilities:
	terraform apply -target=module.kops_utilities -auto-approve

create_yaml:
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=true' \
  	 -var 'deploy_cluster=false' \
	 -var 'update_cluster=false'

destroy_cluster:
	terraform destroy -target=module.kops_cluster

destroy_utilities:
	terraform destroy -target=module.kops_utilities

plan_cluster:
	terraform plan -target=module.kops_cluster

plan_utilities:
	terraform plan -target=module.kops_utilities

update_cluster:
	terraform apply -target=module.kops_cluster -auto-approve \
	 -var 'dry_run=false' \
  	 -var 'deploy_cluster=true' \
	 -var 'update_cluster=true'





