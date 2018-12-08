data "aws_region" "current" {}

locals {
  autoscaler              = "tmp/cluster-autoscaler.yaml"
  cluster_auto_scaler_url = "https://raw.githubusercontent.com/kubernetes/kops/master/addons/cluster-autoscaler/v1.10.0.yaml"
  image                   = "k8s.gcr.io/cluster-autoscaler:v1.1.0"
  instance_group          = "nodes"
  provider                = "aws"
  ssl_cert_path           = "/etc/ssl/certs/ca.crt"
}

data "template_file" "cluster_auto_scaler" {
  template = "${file("${path.module}/bin/cluster_autoscaler.tpl")}"

  vars {
    autoscaler              = "${local.autoscaler}"
    aws_region              = "${data.aws_region.current.name}"
    cloud_provider          = "${local.provider}"
    cluster_auto_scaler_url = "${local.cluster_auto_scaler_url}"
    cluster_deployed        = "${var.cluster_deployed}"
    cluster_name            = "${var.kops_cluster_name}"
    group_name              = "${local.instance_group}.${var.kops_cluster_name}"
    iam_role                = "masters.${var.kops_cluster_name}"
    image                   = "${local.image}"
    instance_group          = "${local.instance_group}"
    kops_cluster_name       = "${var.kops_cluster_name}"
    kops_state_bucket_name  = "${var.kops_state_bucket_name}"
    max_nodes               = "${var.max_nodes}"
    min_nodes               = "${var.min_nodes}"
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

resource "null_resource" "destroy_cluster_autoscaler" {
  provisioner "local-exec" {
    command = "kubectl delete deploy  cluster-autoscaler -n kube-system"
    when    = "destroy"
  }
}
