# **KOPS TERRAFORM MODULE**

I've been teaching myself k8s so I decided to designed a module to build/update clusters using kops as the underlining management tool. This module can preform rolling updates on a cluster, however not all parameters should be updates in this manner, in which case a classic blue/green switch should be preformed.(this modules uses terraform workspaces which facilitaties this workflow).This is experimental, but I am fairly comfortable with the behavior of the cluster creation (`terraform apply -target=module.kops_cluster`) and destruction (`terraform destroy -target=module.kops_cluster`) processes. Cluster updates however is very **buggy** and there are a few exceptions I have not quite fully understood so for now limit your infrastructure updates to upgrades only ( t2.micro -> t2.medium e.g) and to only variables ive tagged `#UPDATEABLE` in the terraform.tfvars file. You can also produce a (cluster_name).yaml file by setting `deploy_cluster = "false"` and `dry_run = "true"`. Change `dry_run = "false"` to generate terraform files for the cluster without applying. A tmp folder is created to house all the local_file resources created during execution of a module.The update process was adopted from [kops via terraform](https://github.com/kubernetes/kops/blob/master/docs/terraform.md).To get this working you'll need to create a file for the tiller rbac ({path_root}/tiller-rbac/rbac-config.yaml) which should be used to define the [cluster role binding](https://github.com/helm/helm/blob/master/docs/rbac.md) for tiller. It's purposely not defined in the pre-req.

## **Prerequisites**

- AWS ACCOUNT !!
- **Domain Name:** This is k8s so you'll need your own domain name
- **Dommain Certificate**: Create a Domain Cert for the Domain Name you'll use for the cluster. Do this ahead of time as it takes sometime to authenticate. [Request a Public Certificate](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html)
- **Terraform S3 Bucket**:Create an s3 bucket to house your terraform state files. [Remote state backend](https://www.terraform.io/docs/backends/types/s3.html)
- [**Kubectl**](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [**Helm**](https://docs.helm.sh/using_helm/)
- [**Kops**](https://github.com/kubernetes/kops/blob/master/docs/install.md)
- [**Terraform**](https://youdontgetalink.lookitupyaself)

## **Usage**

**Create YAML for Cluster**

```bash
sed -i "" '/deploy_cluster     =/ s/= .*/= \"false\"/' ./main.tf && \
sed -i "" '/dry_run =/ s/= .*/= \"true\"/' ./main.tf && \
sed -i "" '/update_cluster =/ s/= .*/= \"false\"/' ./main.tf &&
terraform apply -target=module.kops_cluster -auto-approve
```

**Create Terraform For Cluster**

```bash
sed -i "" '/deploy_cluster     =/ s/= .*/= \"false\"/' ./main.tf && \
sed -i "" '/dry_run =/ s/= .*/= \"false\"/' ./main.tf && \
sed -i "" '/update_cluster =/ s/= .*/= \"false\"/' ./main.tf && \
terraform apply -target=module.kops_cluster -auto-approve
```

**Create Cluster**

```bash
sed -i "" '/deploy_cluster     =/ s/= .*/= \"true\"/' ./main.tf && \
sed -i "" '/dry_run =/ s/= .*/= \"false\"/' ./main.tf && \
sed -i "" '/update_cluster =/ s/= .*/= \"false\"/' ./main.tf && \
terraform apply -target=module.kops_cluster -auto-approve
```

**Create Utilities Services**

```bash
terraform apply -target=module.kops_utilities -auto-approve
```

**Updates Cluster**

```bash
sed -i "" '/deploy_cluster     =/ s/= .*/= \"true\"/' ./main.tf && \
sed -i "" '/dry_run =/ s/= .*/= \"false\"/' ./main.tf && \
sed -i "" '/update_cluster =/ s/= .*/= \"true\"/' ./main.tf && \
terraform apply -target=module.kops_cluster -auto-approve
```

**Login into cluster instance**

_Please Note:user will depending on image coreos used here_

```bash
ssh core@{api or bastion}.{terraform.workspace}.{kops_cluster_name} -i {project.root}/keys/{keypair_name}.pem
```

**Delete Cluster**

```bash
terraform destroy -target=module.kops_cluster
```

**Delete Utilities**

```bash
terraform destroy -target=module.kops_utilities
```

## **TODO**

- Complete Networkings Abstraction from Auto-Gen Terraform code.
- Test Updating remaining parameters
- Introduce additional k8s utilities services (envoy,etc)
- Further parameterize helm install utilities
- Resolve any associated bugs with updating the cluster
- R/v pipelines for uncessessary coding
- Documment k8s utilities
- Persistant volume integration
- ~~Move Consul to Helm Provider~~ DONE
- Deploy a LM Collector within Cluster
- Create a Lambda function to backup and snapshot the etcd volumes for recovery
- create a DR proceedure
- Install end user apps and figure out DNS switching for blue/green deployments
- Added Rook
- Determine approach for standardizing liveness and readyness probes
- Calico Deep Dive
- https://github.com/bitnami-labs/kubewatch
- Research Issue
  - https://github.com/kubernetes/kops/issues/834 - This issues directly relates to ACM+ELB cluster creation.
  - https://github.com/kubernetes/kops/pull/5414 - related pull request
  - https://github.com/ramitsurana/awesome-kubernetes
