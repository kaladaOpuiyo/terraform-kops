##########################################################################
# CERTS & KEYS 
##########################################################################
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

###########################################################################
# NETWORKING
###########################################################################
resource "aws_vpc" "kops_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  instance_tenancy     = "${var.instance_tenancy}"

  tags {
    Name        = "${var.kops_cluster_name}-vpc"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "kops_igw" {
  vpc_id = "${aws_vpc.kops_vpc.id}"

  tags {
    Name        = "${var.kops_cluster_name}"
    Environment = "${terraform.workspace}"
  }
}

# resource "aws_subnet" "kops_subnet" {
#   count                   = "${length(var.subnets)}"
#   vpc_id                  = "${aws_vpc.kops_vpc.id}"
#   cidr_block              = "${lookup(var.subnets["${element(keys(var.subnets),count.index)}"], "cidr_block")}"
#   map_public_ip_on_launch = "${lookup(var.subnets["${element(keys(var.subnets),count.index)}"], "type")  == "public" ? true : false}"

#   availability_zone = "${var.availability_zone}"

#   tags = {
#     Name        = "${var.kops_cluster_name}-${var.availability_zone}-${replace(element(keys(var.subnets),count.index), "/(.-)/", "$3")}"
#     Environment = "${terraform.workspace}"
#   }
# }

# resource "aws_route_table" "kops_route_table" {
#   count = "${length(var.route_tables)}"

#   vpc_id = "${aws_vpc.kops_vpc.id}"

#   tags {
#     Name        = "${var.kops_cluster_name}-${var.az}-${element(var.route_tables, count.index)}-route-table"
#     Environment = "${terraform.workspace}"
#   }
# }

# resource "aws_route" "kops_route" {
#   count = "${length(var.route_tables)}"

#   route_table_id = "${element(aws_route_table.kops_route_table.*.id, count.index)}"

#   destination_cidr_block = "${var.destination_cidr_block}"

#   gateway_id = "${element(var.route_tables, count.index) 
#                               == "public"  ? data.aws_internet_gateway.kops_igw.id: 
#                   element(var.route_tables, count.index) 
#                               == "private" ? "${join("",data.aws_nat_gateway.kops_ngw.*.id)}": "" }"
# }

# resource "aws_route_table_association" "aux_route_table_association" {
#   count     = "${length(var.subnets)}"
#   subnet_id = "${element(aws_subnet.aux_subnet.*.id, count.index)}"

#   route_table_id = "${lookup(var.subnets["${element("${keys(var.subnets)}",count.index)}"], "type")  
#                       == "public" ?join("",data.aws_route_table.public.*.id): 
#                       lookup(var.subnets["${element("${keys(var.subnets)}",count.index)}"], "type")  
#                       == "private" ?join("",data.aws_route_table.private.*.id): ""  }"

#   depends_on = ["aws_route_table.aux_route_table", "aws_subnet.aux_subnet"]
# }

#############################################################################
# IAM  
#############################################################################
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

##########################################################################
# S3
##########################################################################
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

##########################################################################
# Local Magic
##########################################################################
resource "local_file" "kops_init" {
  content  = "${data.template_file.kops_init.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_init.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
  }
}

data "template_file" "kops_init" {
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
    vpc                    = "${aws_vpc.kops_vpc.id}"
    topology               = "${var.topology}"
    network_cidr           = "${aws_vpc.kops_vpc.cidr_block}"
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
    out                    = "${var.out}"
    ssh_public_key         = "${module.kops_keypair.public_key_filepath}"
    ssh_private_key        = "${module.kops_keypair.private_key_filepath}"
    bastion                = "${var.bastion}"
    update_cluster         = "${var.update_cluster}"
    deployCluster          = "${var.deployCluster}"
  }
}

resource "local_file" "kops_destroy" {
  content  = "${data.template_file.kops_destroy.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_destroy.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
    when    = "destroy"
  }
}

data "template_file" "kops_destroy" {
  template = "${file("${path.module}/bin/kops_destroy.tpl")}"

  vars {
    kops_state_store  = "s3://${replace(aws_s3_bucket.kops_state.arn,"arn:aws:s3:::","")}"
    kops_cluster_name = "${var.kops_cluster_name}"
    dry_run           = "${var.dry_run}"
    out               = "${var.out}"
  }
}

resource "local_file" "kops_tf" {
  count    = "${var.dry_run=="false"?1:0}"
  content  = "${data.template_file.kops_tf.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_tf.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
  }

  depends_on = ["local_file.kops_init"]
}

data "template_file" "kops_tf" {
  template = "${file("${path.module}/bin/kops_tf.tpl")}"

  vars {
    cluster_bucket = "${var.cluster_bucket}"
    cluster_key    = "${var.cluster_key}"
    cluster_region = "${var.cluster_region}"
    deployCluster  = "${var.deployCluster}"
    out            = "${var.out}"
  }
}
