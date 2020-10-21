#
# Cookbook:: jenkinsinstall
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

execute 'yum_update_upgrade' do
    command 'yum update -y && yum upgrade -y'
end

execute 'create_fs' do
    command 'mkfs -t xfs /dev/xvdb'
    not_if 'file -s /dev/xvdb | grep filesystem'
end

execute 'mount_fs' do
    command 'mkdir /var/lib/jenkins && mount /dev/xvdb /var/lib/jenkins && echo "/dev/xvdb  /var/lib/jenkins  xfs  defaults,nofail  0  2" >>/etc/fstab'
    not_if 'mount | grep jenkins'
end
