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

resource "kubernetes_role_binding" "rook_ceph_mgmt" {
  metadata {
    name      = "rook-ceph-cluster-mgmt"
    namespace = "rook-ceph"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "rook-ceph-cluster-mgmt"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "rook-ceph-system"
    namespace = "rook-ceph-system"
    api_group = ""
  }

  depends_on = ["null_resource.rook_ceph_roles"]
}

# Allow the osd pods in this namespace to work with configmaps
resource "kubernetes_role_binding" "rook_ceph_osd" {
  metadata {
    name      = "rook-ceph-osd"
    namespace = "rook-ceph"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "rook-ceph-osd"
  }


  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.rook_ceph_osd.metadata.0.name}"
    namespace = "${kubernetes_namespace.rook_ceph.metadata.0.name}"
  }

  depends_on = ["null_resource.rook_ceph_roles"]
}

# # Allow the ceph mgr to access the cluster-specific resources necessary for the mgr modules
resource "kubernetes_role_binding" "rook_ceph_mgr" {
  metadata {
    name      = "rook-ceph-mgr"
    namespace = "rook-ceph"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "rook-ceph-mgr"
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.rook_ceph_mgr.metadata.0.name}"
    namespace = "${kubernetes_namespace.rook_ceph.metadata.0.name}"
  }
}

# # Allow the ceph mgr to access the rook system resources necessary for the mgr modules
resource "kubernetes_role_binding" "rook_ceph_mgr_system" {
  metadata {
    name      = "rook-ceph-mgr-system"
    namespace = "rook-ceph-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "rook-ceph-mgr-system"
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.rook_ceph_mgr.metadata.0.name}"
    namespace = "${kubernetes_namespace.rook_ceph.metadata.0.name}"
  }

  depends_on = ["null_resource.rook_ceph_roles"]
}

# # Allow the ceph mgr to access cluster-wide resources necessary for the mgr modules
resource "kubernetes_role_binding" "rook_ceph_mgr_cluster" {
  metadata {
    name      = "rook-ceph-mgr-cluster"
    namespace = "rook-ceph"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "rook-ceph-mgr-cluster"
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.rook_ceph_mgr.metadata.0.name}"
    namespace = "${kubernetes_namespace.rook_ceph.metadata.0.name}"
  }
  depends_on = ["null_resource.rook_ceph_roles"]
}

# kind: RoleBinding
# apiVersion: rbac.authorization.k8s.io/v1beta1
# metadata:
#   name: rook-ceph-mgr-cluster
#   namespace: rook-ceph
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: rook-ceph-mgr-cluster
# subjects:
# - kind: ServiceAccount
#   name: rook-ceph-mgr
#   namespace: rook-ceph
