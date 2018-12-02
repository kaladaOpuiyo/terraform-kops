#!/bin/bash

EDIT_CONFIG=${path_root}/config/${workspace}/edited.${kops_cluster_name}.yaml


generateTemplate(){
    echo '<======kopsCreateYamlConfig======>'

    mkdir -p ${path_root}/config/${workspace} && \
    kops create cluster \
       --name=edited.${kops_cluster_name} \
       --state=${kops_state_store} \
       --image=${image} \
       --master-size=${master_size} \
       --master-volume-size=${master_volume_size} \
       --master-zones=${master_zone} \
       --master-count=${master_count} \
       --node-size=${node_size} \
       --node-volume-size=${node_volume_size} \
       --node-count=${node_count} \
       --zones=${zones} \
       --admin-access=${admin_access} \
       --associate-public-ip=${associate_public_ip} \
       --topology=${topology} \
       --network-cidr=${network_cidr} \
       --networking=${networking} \
       --vpc=${vpc} \
       --bastion=${bastion} \
       --api-ssl-certificate=${api_ssl_certificate} \
       --api-loadbalancer-type=${api_loadbalancer_type} \
       --authorization=${authorization} \
       --output=${output} \
       --encrypt-etcd-storage=${encrypt_etcd_storage} \
       --kubernetes-version=${kubernetes_version} \
       --dry-run="true" \
       --dns=${dns} \
       --cloud-labels="${cloud_labels}" \
       --cloud=${cloud} \
       --ssh-public-key=${ssh_public_key} \
       --yes > $EDIT_CONFIG
  sed -i '' 's/'edited.${kops_cluster_name}'/'${kops_cluster_name}'/g' $EDIT_CONFIG
}


replaceCluster(){
  echo '<======replaceCluster======>'
 kops replace -f $EDIT_CONFIG  --name=${kops_cluster_name} --state=${kops_state_store} --force
}


updateClusterTerraform(){
  echo '<======updateClusterTerraform======>'
  kops update cluster --name=${kops_cluster_name} --state=${kops_state_store} --target=terraform  --out=${path_root}/${out}/${workspace}
}


########################################################################################################################
  # Main
########################################################################################################################

echo "UPDATE CLUSTER"
generateTemplate
replaceCluster
updateClusterTerraform
