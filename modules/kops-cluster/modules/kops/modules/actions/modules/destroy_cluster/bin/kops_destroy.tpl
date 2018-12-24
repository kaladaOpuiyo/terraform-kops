#!/bin/bash


TF_FILES=${path_root}/${out}/${workspace}
KOPS_CONFIG=${path_root}/config/${workspace}
KOPS_KEYS=${path_root}/keys/${workspace}
TMP_FILES=${path_root}/tmp

kopsDestroy(){
    echo '<======kopsDestroy======>'

                cd $TF_FILES && terraform destroy -auto-approve
                kops delete cluster --state=${kops_state_store} --yes --name=${kops_cluster_name}
}
fileCleanUp(){
echo '<======fileCleanUp======>'
    rm -rf $TF_FILES
    rm -rf $KOPS_CONFIG
    rm -rf $KOPS_KEYS
    rm -rf $TMP_FILES

}
########################################################################################################################
  # Main
########################################################################################################################


        kopsDestroy
        fileCleanUp