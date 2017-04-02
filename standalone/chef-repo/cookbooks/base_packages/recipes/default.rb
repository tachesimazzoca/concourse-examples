[
  'ca-certificates',
  'curl',
  'wget',
  'openssh-client',
  'openssl',
  'git',
  'subversion',
  'vim'
].each do |pkg|
  package pkg do
    action :install
  end
end
