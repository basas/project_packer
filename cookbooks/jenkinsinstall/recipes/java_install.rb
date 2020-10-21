#
# Cookbook:: jenkinsinstall
# Recipe:: java_install
#
# Copyright:: 2020, The Authors, All Rights Reserved.

case node['platform_family']
  when 'debian'
    package 'openjdk-8-jdk'
  when 'rhel', 'amazon', 'fedora'
    package 'java-1.8.0-openjdk'
  else
    raise "`#{node['platform_family']}' is not supported!"
end
