data "external" "check_if_kops_user_exist" {
  program    = ["${path.root}/tmp/${sha1(data.template_file.check_if_kops_user_exist.rendered)}.sh"]
  depends_on = ["local_file.check_if_kops_user_exist"]
}

data "template_file" "check_if_kops_user_exist" {
  template = "${file("${path.module}/bin/check_if_kops_user_exist.tpl")}"

  vars {
    kops_iam_user = "kops"
  }
}

resource "local_file" "check_if_kops_user_exist" {
  content  = "${data.template_file.check_if_kops_user_exist.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.check_if_kops_user_exist.rendered)}.sh"
}
