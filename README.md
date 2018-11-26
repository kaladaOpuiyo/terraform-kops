# KOPS TERRAFORM MODULE

I've been teaching myself k8s so I decided to designed a module to build/update clusters using kops as the underlining management tool. This module can preform rolling updates on a cluster, however not all parameters should be updates in this manner, in which case a classic blue/green switch should be preformed.(this modules uses terraform workspaces which facilitaties this workflow).This is experimental, but I am fairly comfortable with the behavior of the cluster creation (`terraform apply -target=module.kops_cluster`) and destruction (`terraform destroy -target=module.kops_cluster`) processes. Cluster updates however is very **buggy** and there are a few exceptions I have not quite fully understood so for now limit your infrastructure updates to upgrades only ( t2.micro -> t2.medium e.g) and to only variables ive tagged `#UPDATEABLE` in the terraform.tfvars file. You can also produce a (cluster_name).yaml file by setting `deployCluster = "false"` and `dry_run = "true"`. Change `dry_run = "false"` to generate terraform files for the cluster without applying. A tmp folder is created to house all the local_file resources created during execution of a module.The update process was adopted from [kops via terraform](https://github.com/kubernetes/kops/blob/master/docs/terraform.md).To get this working you'll need to create a file for the tiller rbac (tiller-rbac/rbac-config.yaml) which should be used to define the [cluster role binding](https://github.com/helm/helm/blob/master/docs/rbac.md) for tiller. It's purposely not defined in the pre-req. :p

## Prerequisites

- AWS ACCOUNT !!
- **Domain Name:** This is k8s so you'll need your own domain name
- **Dommain Certificate**: Create a Domain Cert for the Domain Name you'll use for the cluster. Do this ahead of time as it takes sometime to authenticate. [Request a Public Certificate](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html)
- **Terraform S3 Bucket**:Create an s3 bucket to house your terraform state files. [Remote state backend](https://www.terraform.io/docs/backends/types/s3.html)
- [**Kubectl**](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [**Helm**](https://docs.helm.sh/using_helm/)
- [**Kops**](https://github.com/kubernetes/kops/blob/master/docs/install.md)
- [**Terraform**](https://youdontgetalink.lookitupyaself) (duh)
-

## Usage

**Create YAML for Cluster**

Set `deployCluster = "false" and dry_run = "true` then run;

```bash
terraform apply -target=module.kops_cluster
```

**Create Terraform For Cluster**

Set `deployCluster = "false" and dry_run = "false` then run;

```bash
terraform apply -target=module.kops_cluster
```

**Create Cluster**

Set `deployCluster = "true" and dry_run = "false` then run;

```bash
terraform apply -target=module.kops_cluster
```

**Create Utilities Services**

```bash
terraform apply -target=module.kops_utilities
```

**Updates**

Set `deployCluster = "true", dry_run = "false, update_cluster = "true"` then run;

```bash
terraform apply -target=module.kops_cluster
```

**Login into cluster instance**

_Please Note:user will depending on image coreos used here_

```bash
ssh core@api.{terraform.workspace}.{kops_cluster_name} -i ~/.ssh/keys/{keypair_name}.pem
```

**Delete Cluster**

```bash
terraform destroy -target=module.kops_cluster
```

**Delete Utilities**

```bash
terraform destroy -target=module.kops_utilities
```

**TODO**:

- Complete Networkings Abstraction from Auto-Gen Terraform code.
- Test Updating remaining parameters
- Introduce additional k8s utilities services (envoy,etc)
- Further parameterize helm install utilities
- Resolve any associated bugs with updating the cluster
- R/v pipelines for uncessessary coding
- Documment k8s utilities
