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
    Environment = "${var.env}"
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

