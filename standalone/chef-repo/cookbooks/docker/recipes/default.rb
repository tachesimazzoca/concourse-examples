apt_repository 'docker-ce' do
  uri 'https://download.docker.com/linux/ubuntu'
  distribution 'xenial'
  components ['stable']
  arch 'amd64' 
  key 'https://download.docker.com/linux/ubuntu/gpg'
end

package 'docker-ce' do
  action :install
end

service 'docker' do
  supports :status => true, :restart => true
  action [:enable, :start]
end

template '/etc/default/docker' do
  source 'etc/default/docker.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[docker]'
end

bash 'ensure docker registry (v2) is running' do
  code <<-EOH
    docker run -d -p #{node['docker']['registry_port']}:5000 --name registry registry:2
  EOH
  only_if "test $(docker ps -aq -f name=registry | wc -l) -eq 0"
end
