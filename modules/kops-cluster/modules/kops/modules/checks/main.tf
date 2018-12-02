data "template_file" "kops_cluster_status" {
  template = "${file("${path.module}/bin/kops_cluster_status.tpl")}"

  vars {
    kops_cluster_name = "${var.kops_cluster_name}"
    kops_state_store  = "${var.kops_state_store}"
  }
}

data "external" "check_if_cluster_exist" {
  program    = ["${path.root}/tmp/${sha1(data.template_file.kops_cluster_status.rendered)}.sh"]
  depends_on = ["local_file.kops_cluster_status"]
}

resource "local_file" "kops_cluster_status" {
  content  = "${data.template_file.kops_cluster_status.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_cluster_status.rendered)}.sh"
}

data "external" "check_if_cluster_needs_rolling_update" {
  program    = ["${path.root}/tmp/${sha1(data.template_file.kops_cluster_rolling_update.rendered)}.sh"]
  depends_on = ["local_file.kops_cluster_rolling_update"]
}

data "template_file" "kops_cluster_rolling_update" {
  template = "${file("${path.module}/bin/kops_cluster_rolling_update.tpl")}"

  vars {
    kops_cluster_name = "${var.kops_cluster_name}"
    kops_state_store  = "${var.kops_state_store}"
  }
}

resource "local_file" "kops_cluster_rolling_update" {
  content  = "${data.template_file.kops_cluster_rolling_update.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_cluster_rolling_update.rendered)}.sh"
}

data "external" "check_if_cluster_deployed" {
  program    = ["${path.root}/tmp/${sha1(data.template_file.check_if_cluster_deployed.rendered)}.sh"]
  depends_on = ["local_file.check_if_cluster_deployed"]
}

data "template_file" "check_if_cluster_deployed" {
  template = "${file("${path.module}/bin/kops_cluster_deployed.tpl")}"

  vars {
    kops_cluster_name = "${var.kops_cluster_name}"
    kops_state_store  = "${var.kops_state_store}"
  }
}

resource "local_file" "check_if_cluster_deployed" {
  content  = "${data.template_file.check_if_cluster_deployed.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.check_if_cluster_deployed.rendered)}.sh"
}
