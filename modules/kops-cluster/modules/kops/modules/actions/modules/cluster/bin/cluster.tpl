#!/bin/bash

TEMP_DIR=${path_root}/tmp/${workspace}
TF_FILES=${path_root}/${out}/${workspace}/kubernetes.tf
TF_PLAN=${path_root}/tmp/${workspace}_cluster.tfplan
EDIT_CONFIG=${path_root}/config/${workspace}/edited.${kops_cluster_name}.yaml
KUBE_CONFIG="~/.kube/config"
KUBELET_FLAGS=(${kubelet_flags})

set -e

addHelmProvider(){

  echo '<======addHelmProvider======>'

HELM_PROVIDER_EXIST=$(cat  ${path_root}/${out}/${workspace}/kubernetes.tf | grep helm > /dev/null && echo true || echo false )

if  [ $HELM_PROVIDER_EXIST = false ];
then
cat >>  $TF_FILES <<EOF
provider "helm" {
  install_tiller  = false
  namespace       = "kube-system"
  enable_tls      = "false"
  service_account = "tiller"
  debug           = true


kubernetes {
    config_path = "$KUBE_CONFIG"
  }

}

resource "null_resource" "cluster_init" {
  provisioner "local-exec" {
    command = "while [ 1 ]; do  kops validate cluster --name=${kops_cluster_name} --state=${kops_state_store} && break || sleep 15; done;"
  }
}

resource "null_resource" "rbac" {
  provisioner "local-exec" {
    command = "while [ 1 ]; do  kubectl create -f ${path_root}/rbac/rbac-config.yaml && break || sleep 5; done;"
  }
  depends_on = ["null_resource.cluster_init"]
}

resource "null_resource" "tiller_deploy" {
  provisioner "local-exec" {
    command = "helm init --service-account tiller --wait"
  }

  depends_on = ["null_resource.rbac"]
}


EOF
fi

}

addRemoteState(){
  echo '<======addRemoteState======>'

BACKEND_SET=$(cat  ${path_root}/${out}/${workspace}/kubernetes.tf | grep \"${cluster_bucket}\" > /dev/null && echo true || echo false )

if  [ $BACKEND_SET = false ];
    then
          sed '/^terraform.*$/r'<(
                  echo "  backend \"s3\" {"
                  echo "    bucket  =  \"${cluster_bucket}\""
                  echo "    key     =  \"${cluster_key}/kops_autogen.tfstate\""
                  echo "    region  =  \"${cluster_region}\""
                  echo "  }"
              )  $TF_FILES > ${path_root}/tmp/kubernetes.tf.tmp

              mv -f ${path_root}/tmp/kubernetes.tf.tmp  $TF_FILES
    else
           echo "backend already set"
fi

}

applyKopsTerraform(){
  echo '<======applyKopsTerraform======>'

    cd ${path_root}/${out}/${workspace} && \
    terraform init -input=false

    if [[ ${deploy_cluster} == true ]];
       then
          terraform plan -out=$TF_PLAN -input=false  && \
          terraform apply -input=false $TF_PLAN
    fi
}

updateInstanceGroup(){
  echo '<======updateInstanceGroup======>'

  if ! [[ -d $TEMP_DIR ]];
      then
          mkdir -p  $TEMP_DIR
  fi

  TEMP=$TEMP_DIR/tmp.${kops_cluster_name}.yaml

  awk '$1 == "name:" { tag = ($2 == "nodes") } tag && $1 == "maxSize:"{$1 = "  " $1; $2 = "${max_nodes}"} 1' $EDIT_CONFIG > $TEMP
  awk '$1 == "name:" { tag = ($2 == "nodes") } tag && $1 == "minSize:"{$1 = "  " $1; $2 = "${min_nodes}"} 1' $TEMP > $EDIT_CONFIG

}



addKubeletFlags(){
 echo '<======addKubeletFlags======>'

  for flag in "$${KUBELET_FLAGS[@]}"
    do
      sed -i '' '/kubelet:.*/s/:.*/: \'$'\n    '"$(echo $flag | sed "s/:/: /")"' /g'  "$EDIT_CONFIG"
  done
}

clusterPubSecret(){
  echo '<======clusterPubSecret======>'
  kops create secret  --name=${kops_cluster_name} --state=${kops_state_store} sshpublickey admin -i ${ssh_public_key}
}
clusterTerraform(){
  echo '<======clusterTerraform======>'
  kops update cluster --name=${kops_cluster_name} --state=${kops_state_store} --target=terraform  --out=${path_root}/${out}/${workspace}
}

createYamlConfig(){
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


rollingUpdateCheck(){
sleep 30
 echo '<======rollingUpdate======>'
     if [[ ${update_cluster} == true ]] || [[ ${need_update} == true ]];
         then
            while [ 1 ]; do kops rolling-update cluster \
            --fail-on-drain-error \
            --name=${kops_cluster_name} --state=${kops_state_store} --yes \
            && break || sleep 5; done;

     fi
}


clusterAutoScaler(){
echo '<======clusterAutoScaler======>'

  wget -O ${autoscaler} ${cluster_auto_scaler_url}

  sed -i '' "s@{{CLOUD_PROVIDER}}@${cloud}@g" "${autoscaler}"
  sed -i '' "s@{{IMAGE}}@${image_cluster_autoscaler}@g" "${autoscaler}"
  sed -i '' "s@{{MIN_NODES}}@${min_nodes}@g" "${autoscaler}"
  sed -i '' "s@{{MAX_NODES}}@${max_nodes}@g" "${autoscaler}"
  sed -i '' "s@{{GROUP_NAME}}@${group_name}@g" "${autoscaler}"
  sed -i '' "s@{{AWS_REGION}}@${aws_region}@g" "${autoscaler}"
  sed -i '' "s@{{SSL_CERT_PATH}}@${ssl_cert_path}@g" "${autoscaler}"

  while [ 1 ]; do  kubectl apply -f ${autoscaler} && break || sleep 5; done;


}


########################################################################################################################
# Main
########################################################################################################################


if  [[ ${dry_run} == true ]];
    then
        createYamlConfig
        addKubeletFlags
        updateInstanceGroup
    else
        if [ ! -f $EDIT_CONFIG ] || [[ ${update_cluster} == true ]];
           then
               createYamlConfig
               addKubeletFlags
               updateInstanceGroup
        fi

        replaceCluster
        clusterPubSecret
        clusterTerraform
        addRemoteState
        addHelmProvider
        applyKopsTerraform
        clusterAutoScaler
        rollingUpdateCheck
fi




