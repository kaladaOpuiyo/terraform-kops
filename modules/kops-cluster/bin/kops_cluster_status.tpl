#!/bin/bash 

# CLUSTER_EXIST=$( { kops get cluster --name=${kops_cluster_name} --state=${kops_state_store}; } 2>&1 | grep "cluster not found \"${kops_cluster_name}\"" )

# echo $CLUSTER_EXIST


# Exit if any of the intermediate steps fail
set -e

# Extract "foo" and "baz" arguments from the input into
# FOO and BAZ shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "FOO=\(.foo) BAZ=\(.baz)"')"


CLUSTER_EXIST=$( { kops get cluster --name=${kops_cluster_name} --state=${kops_state_store}; } 2>&1 | \
grep "cluster not found \"${kops_cluster_name}\""  \
&&  echo false || echo true )

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg result "$CLUSTER_EXIST" '{"CLUSTER_EXIST":$result}'