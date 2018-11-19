#!/bin/bash 

kopKeys(){
    cp -rf ./keys ~/.ssh/ && 
    chmod 400 ~/.ssh/keys/* 
}

kopsCreate(){

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
             --bastion=${bastion} \
             --target=${target} \
             --api-ssl-certificate=${api_ssl_certificate} \
             --api-loadbalancer-type=${api_loadbalancer_type} \
             --authorization=${authorization} \
             --output=${output} \
             --encrypt-etcd-storage=${encrypt_etcd_storage} \
             --kubernetes-version=${kubernetes_version} \
             --dry-run=${dry_run} \
             --dns=${dns} \
             --cloud-labels=${cloud_labels} \
             --cloud=${cloud} \
             --ssh-public-key=${ssh_public_key} \
             --yes > ./config/${kops_cluster_name}.yaml 
 
         if  [ ${dry_run} = "true" ]; 
             then 
                 echo "dry run cluster will not be updated"
             else
                 kops update cluster ${kops_cluster_name}  --yes --state=${kops_state_store} --yes
         fi
    
   
}

kopsUpdate(){
          echo "Still working out the kinks regarding generating an updated kops config file programmatically and then updating the cluster with those changes"
          echo "Considering using blue/green deployments do below command will be uncessary" 
          echo "COMMAND NOT EXECUTED: aws s3 --recursive  mv ${kops_state_store}/${kops_cluster_name} ${kops_state_store}/${kops_cluster_name}"$(date "+%m-%d-%y:%H:%M:%S")"_bak" 
          echo "COMMAND NOT EXECUTED: kops create secret --name ${kops_cluster_name} sshpublickey core -i ${ssh_public_key} --state=${kops_state_store}"
          echo "COMMAND NOT EXECUTED: kops update cluster ${kops_cluster_name} --ssh-public-key=${ssh_public_key} --state=${kops_state_store} --yes"
}

########################################################################################################################
  # Main
########################################################################################################################


if [ ${update_cluster} = "true" ];

    then
        kopsUpdate
    else
        kopKeys
        kopsCreate
fi


