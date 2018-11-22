#!/bin/bash 

BACKEND_SET=$(cat ${path_root}/${out}/kubernetes.tf | grep \"${cluster_bucket}\" > /dev/null && echo true || echo false )
RUN_CHECK=${run_check}

addRemoteState(){
  echo '<======addRemoteState======>'

   sed '/^terraform.*$/r'<(
       echo "  backend \"s3\" {"
       echo "    bucket  =  \"${cluster_bucket}\""
       echo "    key     =  \"${cluster_key}/kops_autogen.tfstate\""
       echo "    region  =  \"${cluster_region}\""
       echo "  }"
   ) ${path_root}/${out}/kubernetes.tf > ${path_root}/tmp/kubernetes.tf.tmp

   mv -f ${path_root}/tmp/kubernetes.tf.tmp ${path_root}/${out}/kubernetes.tf
}

applyKopsTerraform(){
  echo '<======applyKopsTerraform======>'

    cd ${path_root}/${out} && \
    terraform init -input=false && \
    terraform plan -out=${path_root}/tmp/kopsPlan.tfplan -input=false 

    if [ ${deployCluster} = true ];
       then
          terraform apply -input=false ${path_root}/tmp/kopsPlan.tfplan
    fi
}
########################################################################################################################
# Main
########################################################################################################################

 echo $BACKEND_SET



if  [ $BACKEND_SET = false ];
      then 
          addRemoteState
      else 
          echo "backend already set"
fi

applyKopsTerraform
