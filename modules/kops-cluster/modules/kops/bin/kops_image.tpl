#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

curl -s https://coreos.com/dist/aws/aws-stable.json | jq -r '.["us-east-1"]'
