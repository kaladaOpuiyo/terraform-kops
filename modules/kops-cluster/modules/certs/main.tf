##########################################################################
# CERTS & KEYS
##########################################################################
data "aws_acm_certificate" "domain_cert" {
  domain      = "${var.domain_name}"
  most_recent = true
  types       = ["AMAZON_ISSUED"]
}

module "kops_keypair" {
  name   = "${var.keypair_name}"
  path   = "${path.root}/keys/${terraform.workspace}"
  source = "mitchellh/dynamic-keys/aws"
}
