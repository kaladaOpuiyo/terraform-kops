resource "null_resource" "destroy_cluster" {
  triggers {
    destroy_cluster = "${var.destroy_cluster}"
  }

  provisioner "local-exec" {
    command = "${data.template_file.destroy_cluster.rendered}"
    when    = "destroy"
  }
}

data "template_file" "destroy_cluster" {
  template = "${file("${path.module}/bin/destroy_cluster.tpl")}"

  vars {
    kops_state_store  = "${var.kops_state_store}"
    kops_cluster_name = "${var.kops_cluster_name}"
    path_root         = "${path.root}"
    out               = "${var.out}"
    workspace         = "${terraform.workspace}"
  }
}
