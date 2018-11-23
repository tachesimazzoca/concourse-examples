bash 'ensure gpg key is installed' do
  code <<-EOH
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  EOH
  only_if "test $(sudo apt-key fingerprint 0EBFCD88 | wc -l) -eq 0"
end

apt_repository 'docker-ce' do
  uri 'https://download.docker.com/linux/debian'
  distribution 'stretch'
  components ['stable']
  arch 'amd64' 
  key 'https://download.docker.com/linux/debian/gpg'
  notifies :update, 'apt_update[docker-ce]'
end

apt_update 'docker-ce' do
  action :update
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
