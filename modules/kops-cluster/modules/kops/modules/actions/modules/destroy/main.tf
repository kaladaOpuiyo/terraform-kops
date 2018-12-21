resource "null_resource" "kops_destroy" {
  triggers {
    destroy_cluster = "${var.destroy_cluster}"
  }

  provisioner "local-exec" {
    command = "${data.template_file.kops_destroy.rendered}"
    when    = "destroy"
  }
}

data "template_file" "kops_destroy" {
  template = "${file("${path.module}/template/kops_destroy.tpl")}"

  vars {
    kops_state_store  = "${var.kops_state_store}"
    kops_cluster_name = "${var.kops_cluster_name}"
    path_root         = "${path.root}"
    out               = "${var.out}"
    workspace         = "${terraform.workspace}"
  }
}
