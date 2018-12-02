module "kops_user" {
  source             = "./modules/kops_user"
  kops_attach_policy = "${var.kops_attach_policy}"
  kops_user_exist    = "${module.checks.kops_user_exist}"
}

module "checks" {
  source = "./modules/checks"
}
