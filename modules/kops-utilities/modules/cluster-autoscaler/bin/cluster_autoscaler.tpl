#!/bin/bash

#https://github.com/kubernetes/kops/tree/master/addons/cluster-autoscaler
# This is a modified version of ^


set -e

#Set all the variables in this section
CLUSTER_NAME=${cluster_name}
CLOUD_PROVIDER=${cloud_provider}
IMAGE=${image}
MIN_NODES=${min_nodes}
MAX_NODES=${max_nodes}
AWS_REGION=${aws_region}
GROUP_NAME=${group_name}
ASG_NAME=${group_name}
IAM_ROLE=${iam_role}
SSL_CERT_PATH=${ssl_cert_path}
KOP_ACCESS="--state=s3://${kops_state_bucket_name} --name ${cluster_name}"
TEMP=tmp/ig_group.yaml
INSTANCE_GROUP_SET=true


clusterAutoScaler(){
wget -O ${autoscaler} ${cluster_auto_scaler_url}

sed -i '' "s@{{CLOUD_PROVIDER}}@$CLOUD_PROVIDER@g" "${autoscaler}"
sed -i '' "s@{{IMAGE}}@$IMAGE@g" "${autoscaler}"
sed -i '' "s@{{MIN_NODES}}@$MIN_NODES@g" "${autoscaler}"
sed -i '' "s@{{MAX_NODES}}@$MAX_NODES@g" "${autoscaler}"
sed -i '' "s@{{GROUP_NAME}}@$ASG_NAME@g" "${autoscaler}"
sed -i '' "s@{{AWS_REGION}}@$AWS_REGION@g" "${autoscaler}"
sed -i '' "s@{{SSL_CERT_PATH}}@$SSL_CERT_PATH@g" "${autoscaler}"

kubectl apply -f ${autoscaler}
}

updateInstanceGroup(){
 echo "update instance group here"

 kops get ig ${instance_group} --name=$CLUSTER_NAME  --state=s3://${kops_state_bucket_name} -o yaml > $TEMP

 sed -i '' '/minSize:.*/ s/: .*/: ${min_nodes}'/  "$TEMP"

 sed -i '' '/maxSize:.*/ s/: .*/: ${max_nodes}'/  "$TEMP"

 kops replace -f $TEMP $KOP_ACCESS

 kops update cluster $KOP_ACCESS --yes


}

########################################################################################################################
# Main
########################################################################################################################


if [[ ${cluster_deployed} == true ]];
    then
        if [[ INSTANCE_GROUP_SET == false ]];
            then
                updateInstanceGroup
        fi

        clusterAutoScaler
fi