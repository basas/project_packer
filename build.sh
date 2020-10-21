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

#terraform plan
#exit
terraform init
terraform apply -auto-approve -no-color

export PKR_VAR_aws_ebs_snapshopid=$(terraform output aws_ebs_snapshot_ids)
export PKR_VAR_aws_security_group_ids=$(terraform output aws_security_group_ids)


packer build -color=false -force ./jenkins_ami_aws.json

