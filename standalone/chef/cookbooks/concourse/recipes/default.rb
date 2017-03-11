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

[
  '/usr/local/concourse',
  '/usr/local/concourse/bin',
  '/usr/local/concourse/keys'
].each do |x|
  directory x do
    owner 'concourse'
    group 'concourse'
    mode 0700
  end
end

[
  'concourse',
  'fly'
].each do |x|
  bash "ensure /usr/local/bin/#{x}_linux_amd64 is installed" do
    code <<-EOH
      cd /usr/local/concourse/bin
      curl -LO https://github.com/concourse/concourse/releases/download/v2.7.0/#{x}_linux_amd64
      chmod 700 #{x}_linux_amd64
      chown concourse:concourse #{x}_linux_amd64
    EOH
    not_if "test -f /usr/local/concourse/bin/#{x}_linux_amd64"
  end

  link "/usr/local/concourse/bin/#{x}" do
    to "#{x}_linux_amd64"
    owner 'concourse'
    group 'concourse'
  end
end

[
  "tsa_host_key",
  "worker_key",
  "session_signing_key"
].each do |x|
  bash "ensure keys/#{x} is generated" do
    code <<-EOH
      cd /usr/local/concourse/keys
      ssh-keygen -t rsa -f #{x} -N ''
    EOH
    not_if "test -f /usr/local/concourse/keys/#{x} && test -f /usr/local/concourse/keys/#{x}.pub"
  end

  file "/usr/local/concourse/keys/#{x}" do
    mode '0600'
    owner 'concourse'
    group 'concourse'
  end

  file "/usr/local/concourse/keys/#{x}.pub" do
    mode '0600'
    owner 'concourse'
    group 'concourse'
  end
end

bash 'ensure keys/authorized_worker_keys contains keys/worker_key.pub' do
  code <<-EOH
    cd /usr/local/concourse/keys
    if ! (diff worker_key.pub authorized_worker_keys);
    then
      cp worker_key.pub authorized_worker_keys
    fi
  EOH
end

file '/usr/local/concourse/keys/authorized_worker_keys' do
  mode '0600'
  owner 'concourse'
  group 'concourse'
end

template '/etc/systemd/system/concourse-web.service' do
  source 'etc/systemd/system/concourse-web.service.erb'
  owner 'root'
  group 'root'
  mode 0644
end

service 'concourse-web.service' do
  action [:enable, :start]
end

template '/etc/systemd/system/concourse-worker.service' do
  source 'etc/systemd/system/concourse-worker.service.erb'
  owner 'root'
  group 'root'
  mode 0644
end

service 'concourse-worker.service' do
  action [:enable, :start]
end
