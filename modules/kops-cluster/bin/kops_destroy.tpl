#!/bin/bash

kopsDestroy(){
    echo '<======kopsDestroy======>'

        if [ ${dry_run} = true ];

            then
                echo "dry run nothing to destroy";exit 0
            else

                cd ${path_root}/${out} && terraform destroy -auto-approve
                kops delete cluster --state=${kops_state_store} --yes --name=${kops_cluster_name}

        fi
}
fileCleanUp(){
echo '<======fileCleanUp======>'
    rm -rf ${path_root}/${out}
    rm -rf ${path_root}/config
    rm -rf ${path_root}/keys
    rm -rf ${path_root}/tmp
    rm -rf ~/.ssh/keys
}
########################################################################################################################
  # Main
########################################################################################################################

kopsDestroy
fileCleanUp
