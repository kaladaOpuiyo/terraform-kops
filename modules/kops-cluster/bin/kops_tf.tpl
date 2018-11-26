#!/bin/bash

BACKEND_SET=$(cat ${path_root}/${out}/kubernetes.tf | grep \"${cluster_bucket}\" > /dev/null && echo true || echo false )
HELM_PROVIDER_EXIST=$(cat ${path_root}/${out}/kubernetes.tf | grep helm > /dev/null && echo true || echo false )
RUN_CHECK=${run_check}
KUBE_CONFIG="~/.kube/config"

addHelmProvider(){
  echo '<======addHelmProvider======>'

if  [ $HELM_PROVIDER_EXIST = false ];
then
cat >> ${path_root}/${out}/kubernetes.tf <<EOF
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
    command = "while [ 1 ]; do  kops validate cluster --name=${kops_cluster_name} --state=${kops_state_store} && break || sleep 30; done;"
  }
}

resource "null_resource" "tiller_rbac" {
  provisioner "local-exec" {
    command = "while [ 1 ]; do  kubectl create -f ${path_root}/tiller-rbac/rbac-config.yaml && break || sleep 5; done;"
  }
  depends_on = ["null_resource.cluster_init"]
}

resource "null_resource" "helm_init" {
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
              ) ${path_root}/${out}/kubernetes.tf > ${path_root}/tmp/kubernetes.tf.tmp

              mv -f ${path_root}/tmp/kubernetes.tf.tmp ${path_root}/${out}/kubernetes.tf
    else
           echo "backend already set"
fi


}

applyKopsTerraform(){
  echo '<======applyKopsTerraform======>'

    cd ${path_root}/${out} && \
    terraform init -input=false && \
    terraform plan -out=${path_root}/tmp/kopsPlan.tfplan -input=false

    if [ ${deploy_cluster} = true ];
       then
          terraform apply -input=false ${path_root}/tmp/kopsPlan.tfplan
    fi
}



rollingUpdate(){
sleep 30
 echo '<======rollingUpdate======>'
     if [ ${update_cluster} = true ] || [ ${need_update} = true ];
         then
            while [ 1 ]; do kops rolling-update cluster \
            --fail-on-validate-error="false" \
            --master-interval=8m \
            --node-interval=8m \
              --name=${kops_cluster_name} --state=${kops_state_store} --yes --cloudonly --force\
            && break || sleep 5; done;

     fi
}
########################################################################################################################
# Main
########################################################################################################################

addRemoteState
addHelmProvider
applyKopsTerraform
rollingUpdate