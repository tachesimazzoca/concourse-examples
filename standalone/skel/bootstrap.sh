#!/bin/sh

apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  python-simplejson

# Add vagrant user
id -u vagrant > /dev/null
if [ $? -eq 1 ];
then
  adduser --disabled-password --gecos "" vagrant
  sudo bash -c 'echo "vagrant ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)'
  mkdir -p /home/vagrant/.ssh \
    && chmod 700 /home/vagrant/.ssh \
    && curl -L -o /home/vagrant/.ssh/authorized_keys \
        "https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub" \
    && chmod 600 /home/vagrant/.ssh/authorized_keys \
    && chown -R vagrant:vagrant /home/vagrant/.ssh
fi

if [ ! -d "/opt/chef" ];
then
  curl -L https://www.chef.io/chef/install.sh | sudo bash -s -- -v 12.19.36
fi
