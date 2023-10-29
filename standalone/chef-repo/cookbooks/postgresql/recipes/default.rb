package 'postgresql' do
  action :install
end

service 'postgresql' do
  supports :status => true, :restart => true
  action [:enable, :start]
end

template '/etc/postgresql/13/main/pg_hba.conf' do
  source 'etc/postgresql/13/main/pg_hba.conf.erb'
  owner 'postgres'
  group 'postgres'
  mode 0640
  notifies :restart, 'service[postgresql]', :immediately
end
