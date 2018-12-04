# **KOPS TERRAFORM MODULE**

This module can deploy a k8s cluster using kops as the underlining management tool. This module can preform rolling updates on a cluster, however not all parameters should be updates in this manner, in which case a classic blue/green switch should be preformed.(this modules uses terraform workspaces which facilitaties this workflow).This is experimental, but I am fairly comfortable with the behavior of the cluster creation (`terraform apply -target=module.kops_cluster`) and destruction (`terraform destroy -target=module.kops_cluster`) processes. Cluster updates however is very **buggy** and there are a few exceptions I have not quite fully understood so for now limit your infrastructure updates to upgrades only ( t2.micro -> t2.medium e.g) and to only variables ive tagged `#UPDATEABLE` in the terraform.tfvars file. You can also produce a (cluster_name).yaml file by setting `deploy_cluster = "false"` and `dry_run = "true"`. Change `dry_run = "false"` to generate terraform files for the cluster without applying. A tmp folder is created to house all the local_file resources created during execution of a module.The update process was adopted from [kops via terraform](https://github.com/kubernetes/kops/blob/master/docs/terraform.md).To get this working you'll need to create a file for the tiller rbac ({path_root}/tiller-rbac/rbac-config.yaml) which should be used to define the [cluster role binding](https://github.com/helm/helm/blob/master/docs/rbac.md) for tiller. It's purposely not defined in the pre-req. Creating YAML or Terraform files generates resources as this is in anticipation of the creation of the cluster, as such run
the destroy command to delete all cluster resources once done.

## **Prerequisites**

- **Domain Name:** This is k8s so you'll need your own domain name
- **Dommain Certificate**: Create a Domain Cert for the Domain Name you'll use for the cluster. Do this ahead of time as it takes sometime to authenticate. [Request a Public Certificate](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html)
- **Terraform S3 Bucket**:Create an s3 bucket to house your terraform state files. [Remote state backend](https://www.terraform.io/docs/backends/types/s3.html)
- [**Kubectl**](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [**Helm**](https://docs.helm.sh/using_helm/)
- [**Kops**](https://github.com/kubernetes/kops/blob/master/docs/install.md)
- [**Terraform**](https://youdontgetalink.lookitupyaself)

## **Kops-Cluster Modules**

- Certs: Used to create private and public keys.
- kops: Heart of all kops related actions
- networking: Currently only a vpc abrstraction
- s3: Bucket to hold kops state

## **Kops-Utilities Modules**

All charts are base line configs nothing special.

- consul
- envoy
- vault
- fluentd_elasticsearch
- k8s_dashboard
- metrics_server
- rook

## **Usage**

**Intialize Terraform**

```bash
make init
```

**Create Iam Kops resources**

```bash
make create_user
```

**Create YAML for Cluster**

```bash
make create_yaml
```

**Create Terraform For Cluster**

```bash
make create_terraform
```

**Create Cluster**

```bash
make create_cluster (module=name)
```

**Create Utilities Services**

```bash
make create_utilities (module=name)
```

**Updates Cluster**

```bash
make update_cluster (module=kops)
```

**Plan Cluster**

```bash
make plan_cluster (module=name)
```

**Plan Kops IAM**

```bash
make plan_user
```

**Plan Utilities**

```bash
make plan_utilities (module=name)
```

**Delete Cluster**

```bash
make destroy_cluster (module=name)
```

**Delete Kops IAM**

```bash
make destroy_user
```

**Delete Utilities**

```bash
make destroy_utilities (module=name)
```

**Login into cluster instance**

_Please Note:user will depending on image coreos used here_

```bash
ssh core@{api or bastion}.{terraform.workspace}.{kops_cluster_name} -i {project.root}/keys/{keypair_name}.pem
```

## **TODO**

- ~~BUG: Prevent cluster destroy from running when a command other than destroy is requested~~ Seems to be fixed will continue to observer behavior
- Implement [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator#kops-usage)

- Complete Networking Abstraction from Auto-Gen Terraform code.
- Test Updating remaining parameters
- ~~Added Makefile :)~~
- ~~Introduce additional k8s utilities services (envoy,vault)~~ DONE
- Further parameterize helm install utilities
- Resolve any associated bugs with updating the cluster
- ~~R/v pipelines for uncessessary coding for kops-cluster~~ DONE
- R/v pipelines for uncessessary coding for kops
- Documment k8s utilities
- Persistant volume integration
- ~~Move Consul to Helm Provider~~ DONE
- Deploy a LM Collector within Cluster
- Create a Lambda function to backup and snapshot the etcd volumes for recovery
- create a DR proceedure
- Install end user apps and figure out DNS switching for blue/green deployments
- ~~Added Rook~~ DONE
- Determine approach for standardizing liveness and readyness probes
- Calico Deep Dive
- https://github.com/bitnami-labs/kubewatch
- Research Issue
  - ~~https://github.com/kubernetes/kops/issues/834 - This issues directly relates to ACM+ELB cluster creation.~~ ISSUE resolved on kops master branch
  - https://github.com/kubernetes/kops/pull/5414 - related pull request
  - https://github.com/ramitsurana/awesome-kubernetes
  - https://github.com/hashicorp/terraform/issues/18026
  - https://github.com/hashicorp/terraform/issues/13549
  - Interesting EKS vs KOPS chat: https://github.com/kubernetes/kops/issues/5001
  - ~~https://github.com/kubernetes/kops/issues/5757 -relates to ACM+ELB cluster creation with terraform~~ ISSUE resolved on kops master branch
