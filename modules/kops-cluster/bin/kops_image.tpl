#!/bin/bash 

curl -s https://coreos.com/dist/aws/aws-stable.json | jq -r '.["us-east-1"]'
