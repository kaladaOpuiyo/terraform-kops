#!/bin/bash

#https://github.com/kubernetes/kops/tree/master/addons/cluster-autoscaler
# This is a modified version of ^


# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

#Set all the variables in this section
CLUSTER_NAME=${cluster_name}
CLOUD_PROVIDER=${cloud_provider}
IMAGE=${image}
MIN_NODES=${min_nodes}
MAX_NODES=${max_nodes}
AWS_REGION=${aws_region}
GROUP_NAME=${group_name}
ASG_NAME=${asg_name}
IAM_ROLE=${iam_role}
SSL_CERT_PATH=${ssl_cert_path}




wget -O ${addon} ${cluster_auto_scaler_url}

sed -i -e "s@{{CLOUD_PROVIDER}}@aws@g" "${addon}"
sed -i -e "s@{{IMAGE}}@k8s.gcr.io/cluster-autoscaler:v1.1.0@g" "${addon}"
sed -i -e "s@{{MIN_NODES}}@2@g" "${addon}"
sed -i -e "s@{{MAX_NODES}}@20@g" "${addon}"
sed -i -e "s@{{GROUP_NAME}}@nodes@g" "${addon}"
sed -i -e "s@{{AWS_REGION}}@us-east-1@g" "${addon}"
sed -i -e "s@{{SSL_CERT_PATH}}@/etc/ssl/certs/ca.crt@g" "${addon}"

kubectl apply -f ${addon}

