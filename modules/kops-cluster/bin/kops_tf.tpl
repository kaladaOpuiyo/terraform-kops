#!/bin/bash 

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
    terraform plan -out=../tmp/kopsPlan.tfplan -input=false && \
    terraform apply -input=false ../tmp/kopsPlan.tfplan
}
########################################################################################################################
  # Main
########################################################################################################################

addRemoteState
applyKopsTerraform
