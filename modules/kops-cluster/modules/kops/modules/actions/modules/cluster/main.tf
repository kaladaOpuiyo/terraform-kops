data "aws_region" "current" {}

locals {
  autoscaler               = "${path.root}/tmp/cluster-autoscaler.yaml"
  cluster_auto_scaler_url  = "https://raw.githubusercontent.com/kubernetes/kops/master/addons/cluster-autoscaler/v1.10.0.yaml"
  image_cluster_autoscaler = "k8s.gcr.io/cluster-autoscaler:v1.1.0"
  instance_group           = "nodes"
  provider                 = "aws"
  ssl_cert_path            = "/etc/ssl/certs/ca.crt"
}

resource "local_file" "cluster" {
  content = "${data.template_file.cluster.rendered}"

  filename = "${path.root}/tmp/${sha1(data.template_file.cluster.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
  }
}

data "template_file" "cluster" {
  template = "${file("${path.module}/bin/cluster.tpl")}"

  vars {
    admin_access             = "${var.admin_access}"
    api_loadbalancer_type    = "${var.api_loadbalancer_type}"
    api_ssl_certificate      = "${var.api_loadbalancer_type == "" ? "": var.domain_cert_arn}"
    associate_public_ip      = "${var.associate_public_ip}"
    authorization            = "${var.authorization}"
    autoscaler               = "${local.autoscaler}"
    aws_region               = "${data.aws_region.current.name}"
    bastion                  = "${var.bastion}"
    cloud                    = "${var.cloud}"
    cloud_labels             = "${var.cloud_labels}"
    cloud_provider           = "${local.provider}"
    cluster_auto_scaler_url  = "${local.cluster_auto_scaler_url}"
    cluster_bucket           = "${var.cluster_bucket}"
    cluster_deployed         = "${var.cluster_deployed}"
    cluster_key              = "${var.cluster_key}"
    cluster_name             = "${var.kops_cluster_name}"
    cluster_region           = "${var.cluster_region}"
    deploy_cluster           = "${var.deploy_cluster}"
    dns                      = "${var.dns}"
    dry_run                  = "${var.dry_run}"
    encrypt_etcd_storage     = "${var.encrypt_etcd_storage}"
    group_name               = "${local.instance_group}.${var.kops_cluster_name}"
    iam_role                 = "masters.${var.kops_cluster_name}"
    image                    = "${var.ami}"
    image_cluster_autoscaler = "${local.image_cluster_autoscaler}"
    instance_group           = "${local.instance_group}"
    kops_cluster_name        = "${var.kops_cluster_name}"
    kops_state_bucket_name   = "${var.kops_state_bucket_name}"
    kops_state_store         = "${var.kops_state_store}"
    kubelet_flags            = "${join(" ",var.kubelet_flags)}"
    kubernetes_version       = "${var.kubernetes_version}"
    master_count             = "${var.master_count}"
    master_size              = "${var.master_size}"
    master_volume_size       = "${var.master_volume_size}"
    master_zone              = "${var.master_zone}"
    max_nodes                = "${var.max_nodes}"
    min_nodes                = "${var.min_nodes}"
    need_update              = "${var.need_update}"
    network_cidr             = "${var.network_cidr}"
    networking               = "${var.networking}"
    node_count               = "${var.node_count}"
    node_size                = "${var.node_size}"
    node_volume_size         = "${var.node_volume_size}"
    out                      = "${var.out}"
    output                   = "${var.output}"
    path_module              = "${path.module}"
    path_root                = "${path.root}"
    ssh_private_key          = "${var.ssh_private_key}"
    ssh_public_key           = "${var.ssh_public_key}"
    ssl_cert_path            = "${local.ssl_cert_path}"
    target                   = "${var.target}"
    topology                 = "${var.topology}"
    update_cluster           = "${var.update_cluster}"
    vpc                      = "${var.vpc_id}"
    workspace                = "${terraform.workspace}"
    zones                    = "${var.zones}"
  }
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name        = "aws-cluster-autoscaler"
  description = "aws-cluster-autoscaler"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_policy" {
  role       = "masters.${var.kops_cluster_name}"
  policy_arn = "${aws_iam_policy.cluster_autoscaler_policy.arn}"

  depends_on = ["local_file.cluster"]
}
