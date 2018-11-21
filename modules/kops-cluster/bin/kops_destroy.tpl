#!/bin/bash 

kopsDestroy(){
    echo '<======kopsDestroy======>'

        if [ ${dry_run} = "true" ];  
        
            then 
                echo "dry run nothing to destroy";exit 0
            else
                kops delete cluster --state=${kops_state_store} --yes --name=${kops_cluster_name}
                cd ./${out} terraform destroy -input=false
                rm -rf ./${out} 
                rm -rf ./config 
                rm -rf ~/.ssh/keys
                
        fi
}
########################################################################################################################
  # Main
########################################################################################################################

kopsDestroy
