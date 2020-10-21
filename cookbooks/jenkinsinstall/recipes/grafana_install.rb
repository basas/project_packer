#
# Cookbook:: jenkinsinstall
# Recipe:: grafana_install
#
# Copyright:: 2020, The Authors, All Rights Reserved.

%w(dashboards datasources).each do |dir|
  directory "/etc/opt/docker/grafana/provisioning/#{dir}" do
    mode        '0755'
    recursive   true
  end
end

template '/etc/opt/docker/grafana/provisioning/datasources/datasource_prometheus.yaml' do
  source    'grafana_datasource_prometheus.erb'
  mode      '0755'
  notifies  :restart, 'docker_container[grafana]', :delayed
end

cookbook_file '/etc/opt/docker/grafana/provisioning/dashboards/default.yaml' do
  source    'grafana_dashboards_default.yaml'
  mode      '0755'
  action    :create_if_missing
  notifies  :restart, 'docker_container[grafana]', :delayed
end

cookbook_file '/etc/opt/docker/grafana/provisioning/dashboards/node-exporter.json' do
  source    'grafana_node-exporter.json'
  mode      '0755'
  action    :create_if_missing
  notifies  :restart, 'docker_container[grafana]', :delayed
end

cookbook_file '/etc/opt/docker/grafana/provisioning/dashboards/docker_metrics.json' do
  source    'grafana_docker_metrics.json'
  mode      '0755'
  action    :create_if_missing
  notifies  :restart, 'docker_container[grafana]', :delayed
end

docker_image 'grafana' do
  repo    'grafana/grafana'
  tag     node['docker_monitor']['grafana']['version']
end

docker_container 'grafana' do
  repo            'grafana/grafana'
  tag             node['docker_monitor']['grafana']['version']
  restart_policy  'always'
  network_mode    'bridge'
  port            '3000:3000'
  env             ['GF_SECURITY_ADMIN_PASSWORD=abrabr123', \
                   'GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/etc/grafana/provisioning/dashboards/node-exporter.json']
  volumes         %w(/etc/opt/docker/grafana/provisioning:/etc/grafana/provisioning \
                   /etc/opt/docker/grafana/provisioning/dashboards:/var/lib/grafana/dashboards)
end
