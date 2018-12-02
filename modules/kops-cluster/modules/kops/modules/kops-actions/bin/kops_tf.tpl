#!/bin/bash

# Exit if any of the intermediate steps fail

TF_FILES=${path_root}/${out}/${workspace}/kubernetes.tf
TF_PLAN=${path_root}/tmp/${workspace}_cluster.tfplan
BACKEND_SET=$(cat  ${path_root}/${out}/${workspace}/kubernetes.tf | grep \"${cluster_bucket}\" > /dev/null && echo true || echo false )
HELM_PROVIDER_EXIST=$(cat  ${path_root}/${out}/${workspace}/kubernetes.tf | grep helm > /dev/null && echo true || echo false )
KUBE_CONFIG="~/.kube/config"


addHelmProvider(){

  echo '<======addHelmProvider======>'

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

resource "null_resource" "tiller_rbac" {
  provisioner "local-exec" {
    command = "while [ 1 ]; do  kubectl create -f ${path_root}/tiller-rbac/rbac-config.yaml && break || sleep 5; done;"
  }
  depends_on = ["null_resource.cluster_init"]
}

resource "null_resource" "tiller_deploy" {
  provisioner "local-exec" {
    command = "helm init --service-account tiller --wait"
  }

  depends_on = ["null_resource.tiller_rbac"]
}


EOF
fi

}

addRemoteState(){
  echo '<======addRemoteState======>'

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
    terraform init -input=false && \
    terraform plan -out=$TF_PLAN -input=false

    if [[ ${deploy_cluster} == true ]];
       then
          terraform apply -input=false $TF_PLAN
    fi
}



rollingUpdateCheck(){
sleep 30
 echo '<======rollingUpdate======>'
     if [[ ${update_cluster} == true ]] || [[ ${need_update} == true ]];
         then
            while [ 1 ]; do kops rolling-update cluster \
            --fail-on-validate-error="false" \
            --name=${kops_cluster_name} --state=${kops_state_store} --yes \
            && break || sleep 5; done;

     fi
}
########################################################################################################################
# Main
########################################################################################################################

addRemoteState
addHelmProvider
applyKopsTerraform
rollingUpdateCheck