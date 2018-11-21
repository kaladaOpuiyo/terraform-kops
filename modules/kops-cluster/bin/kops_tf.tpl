#!/bin/bash 

BACKEND_SET=$(cat ./${out}/kubernetes.tf | grep \"${cluster_bucket}\" > /dev/null && echo true || echo false )


addRemoteState(){
  echo '<======addRemoteState======>'

   sed '/^terraform.*$/r'<(
       echo "  backend \"s3\" {"
       echo "    bucket  =  \"${cluster_bucket}\""
       echo "    key     =  \"${cluster_key}/kops_autogen.tfstate\""
       echo "    region  =  \"${cluster_region}\""
       echo "  }"
   ) ./${out}/kubernetes.tf > ./tmp/kubernetes.tf.tmp

   mv -f ./tmp/kubernetes.tf.tmp ./${out}/kubernetes.tf
}

applyKopsTerraform(){
  echo '<======applyKopsTerraform======>'

    cd ./${out} && \
    terraform init -input=false && \
    terraform plan -out=../tmp/kopsPlan.tfplan -input=false 

    if [ ${deployCluster} = true ];
       then
          terraform apply -input=false ../tmp/kopsPlan.tfplan
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
