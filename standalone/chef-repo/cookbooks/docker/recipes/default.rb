# See also: https://docs.docker.com/engine/install/debian/
bash 'ensure docker.gpg is installed' do
  code <<-EOH
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod 0644 /etc/apt/keyrings/docker.gpg
  EOH
  not_if { ::File.exist?('/etc/apt/keyrings/docker.gpg') }
end

bash 'ensure docker.list is created' do
  code <<-EOH
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
  EOH
  not_if { ::File.exist?('/etc/apt/sources.list.d/docker.list') }
end

#apt_repository 'docker-ce' do
#  uri 'https://download.docker.com/linux/debian'
#  distribution 'bullseye'
#  components ['stable']
#  arch 'amd64'
#  key 'https://download.docker.com/linux/debian/gpg'
#  notifies :update, 'apt_update[docker-ce]'
#end

#apt_update 'docker-ce' do
#  action :update
#end

[
  'docker-ce',
  'docker-ce-cli',
  'containerd.io',
  'docker-buildx-plugin',
  'docker-compose-plugin'
].each do |pkg|
  package pkg do
    action :install
  end
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
