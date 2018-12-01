##########################################################################
# KOPS
##########################################################################

resource "local_file" "kops_init" {
  count    = "${var.update_cluster=="true" ? 0 : 1}"
  content  = "${data.template_file.kops_init.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_init.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
  }
}

data "template_file" "kops_init" {
  template = "${file("${path.module}/bin/kops.tpl")}"

  vars = {
    admin_access           = "${var.admin_access}"
    api_loadbalancer_type  = "${var.api_loadbalancer_type}"
    api_ssl_certificate    = "${var.api_loadbalancer_type == "" ? "" :var.domain_cert_arn}"
    associate_public_ip    = "${var.associate_public_ip}"
    authorization          = "${var.authorization}"
    bastion                = "${var.bastion}"
    cloud                  = "${var.cloud}"
    cloud_labels           = "${var.cloud_labels}"
    cluster_deployed       = "${data.external.check_if_cluster_deployed.result["CLUSTER_DEPLOYED"]?"true":"false"}"
    deploy_cluster         = "${var.deploy_cluster}"
    dns                    = "${var.dns}"
    dry_run                = "${var.dry_run}"
    encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
    image                  = "${var.ami}"
    kops_cluster_name      = "${var.kops_cluster_name}"
    kops_state_bucket_name = "${var.kops_state_bucket_name}"
    kops_state_store       = "${var.kops_state_store}"
    kubernetes_version     = "${var.kubernetes_version}"
    master_count           = "${var.master_count}"
    master_size            = "${var.master_size}"
    master_volume_size     = "${var.master_volume_size}"
    master_zone            = "${var.master_zone}"
    network_cidr           = "${var.network_cidr}"
    networking             = "${var.networking}"
    node_count             = "${var.node_count}"
    node_size              = "${var.node_size}"
    node_volume_size       = "${var.node_volume_size}"
    out                    = "${var.out}"
    output                 = "${var.output}"
    path_root              = "${path.root}"
    ssh_private_key        = "${var.ssh_private_key}"
    ssh_public_key         = "${var.ssh_public_key}"
    target                 = "${var.target}"
    topology               = "${var.topology}"
    update_cluster         = "${var.update_cluster}"
    vpc                    = "${var.vpc_id}"
    zones                  = "${var.zones}"
  }
}

resource "local_file" "kops_destroy" {
  count    = "${var.destroy_cluster ? 1:0}"
  content  = "${data.template_file.kops_destroy.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_destroy.rendered)}.sh"

  provisioner "local-exec" {
    command = "${path.root}/tmp/${sha1(data.template_file.kops_destroy.rendered)}.sh"
    when    = "destroy"
  }

  depends_on = ["local_file.kops_destroy"]
}

data "template_file" "kops_destroy" {
  template = "${file("${path.module}/bin/kops_destroy.tpl")}"

  vars {
    kops_state_store  = "${var.kops_state_store}"
    kops_cluster_name = "${var.kops_cluster_name}"
    path_root         = "${path.root}"
    out               = "${var.out}"
  }
}

resource "local_file" "kops_tf" {
  count = "${var.dry_run == "false" ? 1:0}"

  content  = "${data.template_file.kops_tf.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_tf.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
  }

  depends_on = ["local_file.kops_update", "local_file.kops_init"]
}

data "template_file" "kops_tf" {
  template = "${file("${path.module}/bin/kops_tf.tpl")}"

  vars {
    cluster_bucket    = "${var.cluster_bucket}"
    cluster_key       = "${var.cluster_key}"
    cluster_region    = "${var.cluster_region}"
    deploy_cluster    = "${var.deploy_cluster}"
    kops_cluster_name = "${var.kops_cluster_name}"
    kops_state_store  = "${var.kops_state_store}"
    need_update       = "${data.external.check_if_cluster_needs_rolling_update.result["ROLLING_UPDATE"]?"true":"false"}"
    out               = "${var.out}"
    path_root         = "${path.root}"
    run_check         = "${path.root}/tmp/${sha1(data.template_file.kops_update.rendered)}.sh"
    update_cluster    = "${var.update_cluster}"
  }
}

resource "local_file" "kops_update" {
  count    = "${var.dry_run == "false" && var.update_cluster == "true"  ? 1:0}"
  content  = "${data.template_file.kops_update.rendered}"
  filename = "${path.root}/tmp/${sha1(data.template_file.kops_update.rendered)}.sh"

  provisioner "local-exec" {
    command = "${self.filename}"
  }

  depends_on = ["local_file.kops_init"]
}

data "template_file" "kops_update" {
  template = "${file("${path.module}/bin/kops_update.tpl")}"

  vars = {
    admin_access           = "${var.admin_access}"
    api_loadbalancer_type  = "${var.api_loadbalancer_type}"
    api_ssl_certificate    = "${var.api_loadbalancer_type == "" ? "": var.domain_cert_arn}"
    associate_public_ip    = "${var.associate_public_ip}"
    authorization          = "${var.authorization}"
    bastion                = "${var.bastion}"
    cloud                  = "${var.cloud}"
    cloud_labels           = "${var.cloud_labels}"
    deploy_cluster         = "${var.deploy_cluster}"
    dns                    = "${var.dns}"
    dry_run                = "${var.dry_run}"
    encrypt_etcd_storage   = "${var.encrypt_etcd_storage}"
    image                  = "${var.ami}"
    kops_cluster_name      = "${var.kops_cluster_name}"
    kops_state_bucket_name = "${var.kops_state_bucket_name}"
    kops_state_store       = "${var.kops_state_store}"
    kubernetes_version     = "${var.kubernetes_version}"
    master_count           = "${var.master_count}"
    master_size            = "${var.master_size}"
    master_volume_size     = "${var.master_volume_size}"
    master_zone            = "${var.master_zone}"
    network_cidr           = "${var.network_cidr}"
    networking             = "${var.networking}"
    node_count             = "${var.node_count}"
    node_size              = "${var.node_size}"
    node_volume_size       = "${var.node_volume_size}"
    out                    = "${var.out}"
    output                 = "${var.output}"
    path_root              = "${path.root}"
    run_check              = "${path.root}/tmp/${sha1(data.template_file.kops_init.rendered)}.sh"
    ssh_private_key        = "${var.ssh_private_key}"
    ssh_public_key         = "${var.ssh_public_key}"
    target                 = "${var.target}"
    topology               = "${var.topology}"
    update_cluster         = "${var.update_cluster}"
    vpc                    = "${var.vpc_id}"
    zones                  = "${var.zones}"
  }
}

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
