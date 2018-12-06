data "aws_region" "current" {}

locals {
  addon                   = "tmp/cluster-autoscaler.yml"
  cluster_auto_scaler_url = "https://raw.githubusercontent.com/kubernetes/kops/master/addons/cluster-autoscaler/v1.10.0.yaml"
  image                   = "k8s.gcr.io/cluster-autoscaler:v1.1.0"
  instance_group_name     = "nodes"
  max_nodes               = "10"
  min_nodes               = "2"
  provider                = "aws"
  ssl_cert_path           = "/etc/ssl/certs/ca.crt"
}

data "template_file" "cluster_auto_scaler" {
  template = "${file("${path.module}/bin/cluster_autoscaler.tpl")}"

  vars {
    addon                   = "${local.addon}"
    asg_name                = "${local.instance_group_name}.${var.kops_cluster_name}"
    aws_region              = "${data.aws_region.current.name}"
    cloud_provider          = "${local.provider}"
    cluster_auto_scaler_url = "${local.cluster_auto_scaler_url}"
    cluster_name            = "${var.kops_cluster_name}"
    iam_role                = "masters.${var.kops_cluster_name}"
    image                   = "${local.image}"
    group_name              = "${local.instance_group_name}"
    kops_state_store        = "${var.kops_state_store}"
    kops_cluster_name       = "${var.kops_cluster_name}"
    max_nodes               = "${local.max_nodes}"
    min_nodes               = "${local.min_nodes}"
    ssl_cert_path           = "${local.ssl_cert_path}"
  }
}

resource "local_file" "cluster_auto_scaler" {
  content = "${data.template_file.cluster_auto_scaler.rendered}"

  filename = "${path.root}/tmp/${sha1(data.template_file.cluster_auto_scaler.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
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
}
