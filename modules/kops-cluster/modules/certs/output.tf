output "private_key" {
  value = "${module.kops_keypair.private_key_filepath}"
}

output "public_key" {
  value = "${module.kops_keypair.public_key_filepath}"
}

output "domain_cert_arn" {
  value = "${data.aws_acm_certificate.domain_cert.arn}"
}
