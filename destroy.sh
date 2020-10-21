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
export TF_VAR_region=$AWS_REG

export PKR_VAR_jenkins_adm=$(cat secrets.config | grep jenkins_admin | cut -d= -f2-)
export PKR_VAR_jenkins_adm_pwd=$(cat secrets.config | grep jenkins_adm_pwd | cut -d= -f2-)

AMIID=`cat manifest.json | grep artifact | cut -d: -f3 | tr -d '",'`

aws ec2 deregister-image --image-id $AMIID
echo -n > manifest.json

cd deploy
terraform destroy -auto-approve
cd ..
terraform destroy -auto-approve
