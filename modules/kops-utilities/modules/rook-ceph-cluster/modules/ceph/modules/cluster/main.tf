resource "null_resource" "rook_ceph_cluster" {
  provisioner "local-exec" {
    command = "cat << EOF | kubectl apply -f - \n${data.template_file.rook_ceph_cluster.rendered}EOF"
  }
}

data "template_file" "rook_ceph_cluster" {
  template = "${file("${path.module}/templates/ceph_cluster.tpl")}"

  vars {
    namespace         = "${var.namespace}"
    ceph_cluster_name = "${var.ceph_cluster_name}"
  }
}
