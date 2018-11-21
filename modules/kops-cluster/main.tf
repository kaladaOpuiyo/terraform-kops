data "aws_acm_certificate" "domain_cert" {
  domain      = "${var.domain_name}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

module "kops_keypair" {
  source = "mitchellh/dynamic-keys/aws"
  name   = "${var.keypair_name}"
  path   = "${path.root}/keys"
}

resource "aws_iam_group" "kops" {
  name = "kops"
}

resource "aws_iam_group_policy_attachment" "kops_attach" {
  count      = "${length(var.kops_attach_policy)}"
  group      = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/${element(var.kops_attach_policy,count.index)}"
}

resource "aws_iam_user" "kops" {
  name = "kops"
}

resource "aws_iam_user_group_membership" "kops_membership" {
  user = "${aws_iam_user.kops.name}"

  groups = [
    "${aws_iam_group.kops.name}",
  ]
}

resource "aws_iam_access_key" "kops" {
  user = "${aws_iam_user.kops.name}"
}

resource "aws_s3_bucket" "kops_state" {
  bucket        = "${var.kops_state_bucket_name}"
  acl           = "${var.acl}"
  region        = "${var.region}"
  force_destroy = "${var.force_destroy}"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name        = "${var.kops_state_bucket_name}"
    Environment = "${var.env}"
  }
}

resource "local_file" "kops" {
  content  = "${data.template_file.kops.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
  }
}

data "template_file" "kops" {
  template = "${file("${path.module}/bin/kops.tpl")}"

  vars = {
    image                  = "${var.ami}"
    kops_cluster_name      = "${var.kops_cluster_name}"
    kops_state_bucket_name = "${var.kops_state_bucket_name}"
    kops_state_store       = "s3://${replace(aws_s3_bucket.kops_state.arn,"arn:aws:s3:::","")}"
    master_size            = "${var.master_size}"
    master_count           = "${var.master_count}"
    master_zone            = "${var.master_zone}"
    master_volume_size     = "${var.master_volume_size}"
    node_size              = "${var.node_size}"
    node_count             = "${var.node_count}"
    node_volume_size       = "${var.node_volume_size}"
    zones                  = "${var.zones}"
    networking             = "${var.networking}"
    topology               = "${var.topology}"
    network_cidr           = "${var.network_cidr}"
    target                 = "${var.target}"
    topology               = "${var.topology}"
    admin_access           = "${var.admin_access}"
    api_loadbalancer_type  = "${var.api_loadbalancer_type}"
    api_ssl_certificate    = "${var.api_loadbalancer_type == "" ?"":data.aws_acm_certificate.domain_cert.arn}"
    associate_public_ip    = "${var.associate_public_ip}"
    authorization          = "${var.authorization}"
    cloud                  = "${var.cloud}"
    cloud_labels           = "${var.cloud_labels}"
    dns                    = "${var.dns}"
    dry_run                = "${var.dry_run}"
    encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
    kubernetes_version     = "${var.kubernetes_version}"
    output                 = "${var.output}"
    ssh_public_key         = "${module.kops_keypair.public_key_filepath}"
    ssh_private_key        = "${module.kops_keypair.private_key_filepath}"
    bastion                = "${var.bastion}"
    update_cluster         = "${var.update_cluster}"
  }
}

resource "local_file" "kops_destroy" {
  content  = "${data.template_file.kops_destroy.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_destroy.rendered)}_destroy.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
    when    = "destroy"
  }

  depends_on = ["aws_s3_bucket.kops_state"]
}

data "template_file" "kops_destroy" {
  template = "${file("${path.module}/bin/kops_destroy.tpl")}"

  vars {
    kops_state_store  = "s3://${replace(aws_s3_bucket.kops_state.arn,"arn:aws:s3:::","")}"
    kops_cluster_name = "${var.kops_cluster_name}"
    dry_run           = "${var.dry_run}"
  }
}
