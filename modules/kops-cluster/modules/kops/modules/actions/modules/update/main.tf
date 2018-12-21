resource "null_resource" "kops_update" {
  count = "${var.dry_run == "false" && var.update_cluster == "true"  ? 1:0}"

  provisioner "local-exec" {
    command = "${data.template_file.kops_update.rendered}"
  }
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
    ssh_private_key        = "${var.ssh_private_key}"
    ssh_public_key         = "${var.ssh_public_key}"
    target                 = "${var.target}"
    topology               = "${var.topology}"
    update_cluster         = "${var.update_cluster}"
    vpc                    = "${var.vpc_id}"
    workspace              = "${terraform.workspace}"
    zones                  = "${var.zones}"
  }
}
