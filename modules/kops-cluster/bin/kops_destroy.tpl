#!/bin/bash 

kopsDestroy(){

    if [ ${dry_run} = "true" ];  
    
        then 
            echo "dry run nothing to destroy";exit 0
        else
            kops delete cluster --state=${kops_state_store} --yes --name=${kops_cluster_name}
          
    fi
   
}


kopKeys(){
   rm -rf ~/.ssh/keys
}


########################################################################################################################
  # Main
########################################################################################################################


kopsDestroy
kopKeys