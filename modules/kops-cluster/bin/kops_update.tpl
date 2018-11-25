#!/bin/bash
RUN_CHECK=${run_check}


  
# Need to write update process here runcheck is a trigger from changes to kops_init.
# This is going to be fun. May move the terraform out command to this
# Proposed steps 
# - Generate Yaml from Template ->  kops toolbox template (This is the most challanging thing about all this) [generateTemplate]
# - Replace Config Yaml ->  kops replace -f [replaceCluster]
# - Update Terraform -> kops update cluster --target=terraform [updateClusterTerraform]
generateTemplate(){
    echo '<======kopsCreateYamlConfig======>'

    mkdir -p ./config && \
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
       --yes >  ${path_root}/config/edited.${kops_cluster_name}.yaml
  sed -i '' 's/'edited.${kops_cluster_name}'/'${kops_cluster_name}'/g'  ${path_root}/config/edited.${kops_cluster_name}.yaml  
}


replaceCluster(){
  echo '<======replaceCluster======>'
 kops replace -f  ${path_root}/config/edited.${kops_cluster_name}.yaml  --name=${kops_cluster_name} --state=${kops_state_store} --force
}


updateClusterTerraform(){
  echo '<======updateClusterTerraform======>'
  kops update cluster --name=${kops_cluster_name} --state=${kops_state_store} --target=terraform  --out=${path_root}/${out} 
}


########################################################################################################################
  # Main
########################################################################################################################

echo "UPDATE CLUSTER"
touch ${path_root}/tmp/kops_update  &&  echo "UPDATE CLUSTER:${update_cluster}" > ${path_root}/tmp/kops_update
generateTemplate
replaceCluster
updateClusterTerraform
