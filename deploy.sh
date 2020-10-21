#!/bin/bash

export AWS_AK=$(cat secrets.config | grep aws_access_key_id | cut -d= -f2-)
export AWS_SK=$(cat secrets.config | grep aws_secret_access_key | cut -d= -f2-)
export AWS_REG=$(cat secrets.config | grep region | cut -d= -f2-)

if [ "${AWS_AK}" == "" ]; then
  echo "Secrets not set !"
  exit
fi

export TF_VAR_access_key=$AWS_AK 
export TF_VAR_secret_key=$AWS_SK 
export TF_VAR_ami_id=`cat manifest.json | grep artifact | cut -d: -f3 | tr -d '",'`

cd deploy
terraform init
terraform apply -auto-approve -no-color
#exit

