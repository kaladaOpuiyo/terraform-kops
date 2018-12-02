output "kops_user_exist" {
  value = "${data.external.check_if_kops_user_exist.result["KOPS_USER_EXIST"]}"
}
