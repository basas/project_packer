#
# Cookbook:: jenkinsinstall
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'jenkinsinstall::prepare_system'
include_recipe 'jenkinsinstall::kernel_live_patching'
include_recipe 'jenkinsinstall::java_install'
include_recipe 'jenkins::master'
include_recipe 'jenkinsinstall::jenkins_config'

execute 'yum_repo_add' do
    command 'yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo'
    not_if 'ls /etc/yum.repos.d/hashicorp.repo'
end

yum_package %w(git groovy jq terraform packer) do
    action :install
end
