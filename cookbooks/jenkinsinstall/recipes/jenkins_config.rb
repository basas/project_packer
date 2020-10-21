#
# Cookbook:: jenkinsinstall
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

directory "/var/lib/jenkins" do
    owner   'jenkins'
    group   'jenkins'
    mode        '0755'
    recursive   true
end

directory "/var/lib/jenkins/init.groovy.d" do
    mode        '0755'
    recursive   true
    owner   'jenkins'
    group   'jenkins'
end

cookbook_file '/var/lib/jenkins/init.groovy.d/install_plugins.groovy' do
    source    'install_plugins.groovy'
    mode      '0755'
    owner   'jenkins'
    group   'jenkins'
    action    :create_if_missing
    notifies :restart, 'service[jenkins]', :delayed
end

template '/var/lib/jenkins/init.groovy.d/createuser.groovy' do
    source    'createuser.erb'
    mode      '0755'
    owner   'jenkins'
    group   'jenkins'
    notifies :restart, 'service[jenkins]', :delayed
end

template '/var/lib/jenkins/init.groovy.d/createawscreds.groovy' do
    source    'createawscreds.erb'
    mode      '0755'
    owner   'jenkins'
    group   'jenkins'
    notifies :restart, 'service[jenkins]', :delayed
end

cookbook_file '/var/lib/jenkins/init.groovy.d/install_job.groovy' do
    source    'install_job.groovy'
    mode      '0755'
    owner     'jenkins'
    group     'jenkins'
    action    :create_if_missing
    notifies :restart, 'service[jenkins]', :delayed
end