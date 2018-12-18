resource "null_resource" "kops_destroy" {
  triggers {
    destroy_cluster = "${var.destroy_cluster}"
  }

  provisioner "local-exec" {
    command = "${path.root}/tmp/${var.kops_cluster_name}_destroy.sh"
    when    = "destroy"
  }

  depends_on = ["local_file.kops_destroy"]
}

resource "local_file" "kops_destroy" {
  content  = "${data.template_file.kops_destroy.rendered}"
  filename = "${path.root}/tmp/${var.kops_cluster_name}_destroy.sh"
}

data "template_file" "kops_destroy" {
  template = "${file("${path.module}/bin/kops_destroy.tpl")}"

  vars {
    kops_state_store  = "${var.kops_state_store}"
    kops_cluster_name = "${var.kops_cluster_name}"
    path_root         = "${path.root}"
    out               = "${var.out}"
    workspace         = "${terraform.workspace}"
  }
}
