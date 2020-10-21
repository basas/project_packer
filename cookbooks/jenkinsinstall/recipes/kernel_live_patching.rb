#
# Cookbook:: jenkinsinstall
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.


execute 'yum_install_livepatch' do
    command '  yum install -y yum-plugin-kernel-livepatch && yum kernel-livepatch enable -y'
    not_if 'rpm -qa | grep kernel-livepatch'
    notifies  :run, 'execute[yum_update_kpatch_service]', :delayed
end

execute 'yum_update_kpatch_service' do
    command 'yum update kpatch-runtime && systemctl enable kpatch.service && amazon-linux-extras enable livepatch'
    action :nothing
    notifies  :run, 'execute[yum_update_paches]', :delayed
end

execute 'yum_update_paches' do
    command 'yum update --security'
    action :nothing
end
