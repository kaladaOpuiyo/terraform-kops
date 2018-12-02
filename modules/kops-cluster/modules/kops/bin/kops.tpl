#!/bin/bash


CONFIG=${path_root}/config/${workspace}/${kops_cluster_name}.yaml

kopsCreateYamlConfig(){
    echo '<======kopsCreateYamlConfig======>'

    mkdir -p ${path_root}/config/${workspace} && \
    kops create cluster \
       --name=${kops_cluster_name} \
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
       --yes > $CONFIG
}

kopsCreateTerraform(){
    echo '<======kopsCreateTerraform======>'
    kops create cluster \
       --name=${kops_cluster_name} \
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
       --target=${target} \
       --api-ssl-certificate=${api_ssl_certificate} \
       --api-loadbalancer-type=${api_loadbalancer_type} \
       --authorization=${authorization} \
       --encrypt-etcd-storage=${encrypt_etcd_storage} \
       --kubernetes-version=${kubernetes_version} \
       --dns=${dns} \
       --cloud-labels="${cloud_labels}" \
       --cloud=${cloud} \
       --ssh-public-key=${ssh_public_key} \
       --out=${path_root}/${out}/${workspace} \
       --yes

}


########################################################################################################################
  # Main
########################################################################################################################


if [[ ${deploy_cluster} == false ]] && [[ ${cluster_deployed} == false ]];
    then
        echo '<======CleanUpOfClusterTempData======>'

          cd ${path_root}/${out}/${workspace} && terraform destroy -auto-approve && \
          kops delete cluster --state=${kops_state_store} --yes --name=${kops_cluster_name}
fi

CLUSTER_EXIST=$( { kops get cluster --name=${kops_cluster_name} --state=${kops_state_store}; } 2>&1 | \
grep "cluster not found \"${kops_cluster_name}\""  \
&&  echo false || echo true )

    echo "Cluster Exist":$CLUSTER_EXIST

    if ! [[ $CLUSTER_EXIST == true ]];
        then
            if  [[ ${dry_run} == true ]];
                then
                    kopsCreateYamlConfig
                else

                    kopsCreateYamlConfig
                    kopsCreateTerraform
            fi

    fi



