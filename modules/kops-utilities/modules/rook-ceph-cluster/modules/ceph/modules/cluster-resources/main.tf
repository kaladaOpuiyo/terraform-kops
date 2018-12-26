resource "kubernetes_namespace" "rook_ceph" {
  metadata {
    annotations {
      name = "rook-ceph"
    }

    name = "rook-ceph"
  }
}

resource "kubernetes_service_account" "rook_ceph_osd" {
  metadata {
    name      = "rook-ceph-osd"
    namespace = "${kubernetes_namespace.rook_ceph.metadata.0.name}"
  }
}

resource "kubernetes_service_account" "rook_ceph_mgr" {
  metadata {
    name      = "rook-ceph-mgr"
    namespace = "${kubernetes_namespace.rook_ceph.metadata.0.name}"
  }
}

resource "null_resource" "rook_ceph_roles" {
  provisioner "local-exec" {
    command = "cat <<  EOF | kubectl apply -f - \n${data.template_file.rook_ceph_roles.rendered}EOF"
  }
}

data "template_file" "rook_ceph_roles" {
  template = "${file("${path.module}/templates/ceph_roles.tpl")}"

  vars {
    namespace                     = "${kubernetes_namespace.rook_ceph.metadata.0.name}"
    service_account_rook_ceph_mgr = "${kubernetes_service_account.rook_ceph_mgr.metadata.0.name}"
    service_account_rook_ceph_osd = "${kubernetes_service_account.rook_ceph_osd.metadata.0.name}"
  }
}
