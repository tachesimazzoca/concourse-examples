#!/bin/sh

set -e

# install base packages
apt-get update
apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    rsync

# add vagrant user
id_vagrant=$(id -u vagrant || true)
if [ -z "$id_vagrant" ];
then
  adduser --disabled-password --gecos "" vagrant
  bash -c 'echo "vagrant ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)'
fi

# update vagrant/.ssh/authorized_keys
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
curl -L -o /home/vagrant/.ssh/authorized_keys \
  "https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub"
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

if [ ! -d "/opt/chef" ];
then
  curl -L https://omnitruck.chef.io/install.sh | sudo bash
fi
