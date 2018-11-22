#!/bin/bash
RUN_CHECK=${run_check}


  
# Need to write update process here runcheck is a trigger from changes to kops_init.
# This is going to be fun. May move the terraform out command to this
# Proposed steps 
# - Generate Yaml from Template ->  kops toolbox template (This is the most challanging thing about all this) [generateTemplate]
# - Replace Config Yaml ->  kops replace -f [replaceCluster]
# - Update Terraform -> kops update cluster --target=terraform [updateClusterTerraform]

########################################################################################################################
  # Main
########################################################################################################################

echo "UNDER CONSTRUCTON MOVE ALONG"
echo "NO AUTOMATED UPDATES HERE SIR/MADAM"

# cat ${path_root}/tmp/kops_update 