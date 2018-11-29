output "vpc_id" {
  value = "${aws_vpc.kops_vpc.id}"
}

output "network_cidr" {
  value = "${aws_vpc.kops_vpc.cidr_block}"
}
