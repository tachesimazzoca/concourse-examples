bash 'createdb -U cocourse concourse' do
  user 'postgres'
  code <<-EOH
    if ! (echo "$(psql -lqt | awk -F'[|]' '{print $1}')" | grep 'concourse');
    then
      createuser -S -d -R concourse
      createdb -U concourse concourse
    fi
  EOH
end

user 'concourse' do
  home '/home/concourse'
  shell '/bin/bash'
  password nil
  manage_home true
end

bash "ensure /usr/local/concourse is installed" do
  code <<-EOH
    cd /usr/local/src
    curl -LO https://github.com/concourse/concourse/releases/download/v7.10.0/concourse-7.10.0-linux-amd64.tgz
    tar xvfz concourse-7.10.0-linux-amd64.tgz -C /usr/local
    mkdir -p /usr/local/concourse/keys
    chown concourse:concourse -R /usr/local/concourse
  EOH
  not_if "test -d /usr/local/concourse"
end

#[
#  "tsa_host_key",
#  "worker_key",
#  "session_signing_key"
#].each do |x|
#  bash "ensure keys/#{x} is generated" do
#    code <<-EOH
#      cd /usr/local/concourse/keys
#      ssh-keygen -t rsa -f #{x} -N ''
#    EOH
#    not_if "test -f /usr/local/concourse/keys/#{x} && test -f /usr/local/concourse/keys/#{x}.pub"
#  end
#
#  file "/usr/local/concourse/keys/#{x}" do
#    mode '0600'
#    owner 'concourse'
#    group 'concourse'
#  end
#
#  file "/usr/local/concourse/keys/#{x}.pub" do
#    mode '0600'
#    owner 'concourse'
#    group 'concourse'
#  end
#end

#bash 'ensure keys/authorized_worker_keys contains keys/worker_key.pub' do
#  code <<-EOH
#    cd /usr/local/concourse/keys
#    if ! (diff worker_key.pub authorized_worker_keys);
#    then
#      cp worker_key.pub authorized_worker_keys
#    fi
#  EOH
#end
#
#file '/usr/local/concourse/keys/authorized_worker_keys' do
#  mode '0600'
#  owner 'concourse'
#  group 'concourse'
#end
#
#execute 'systemctl daemon-reload' do
#  action :nothing
#end
#
#template '/etc/systemd/system/concourse-web.service' do
#  source 'etc/systemd/system/concourse-web.service.erb'
#  owner 'root'
#  group 'root'
#  mode 0644
#  notifies :run, 'execute[systemctl daemon-reload]', :immediately
#  notifies :restart, 'service[concourse-web.service]'
#end
#
#service 'concourse-web.service' do
#  action [:enable, :start]
#  supports :restart => true, :reload => false, :status => true
#end
#
#template '/etc/systemd/system/concourse-worker.service' do
#  source 'etc/systemd/system/concourse-worker.service.erb'
#  owner 'root'
#  group 'root'
#  mode 0644
#  notifies :run, 'execute[systemctl daemon-reload]', :immediately
#  notifies :restart, 'service[concourse-worker.service]'
#end
#
#service 'concourse-worker.service' do
#  action [:enable, :start]
#  supports :restart => true, :reload => false, :status => true
#end
