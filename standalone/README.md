# concourse-examples

## Ubuntu 16.04.2 LTS with Vagrant

Concouse standalone binary requires Linux kernel 3.19+ and PostgreSQL 9.3+. This examples uses [ubuntu/xenial64 in Atlas](https://atlas.hashicorp.com/ubuntu/boxes/xenial64) as a base box.

    $ make

    # Modify your private ip
    $ vi Vagrantfile
    ...
    config.vm.network "private_network", ip: "xxx.xxx.xxx.xxx"

    $ vagrant up

This image has the `ubuntu` user as a sudoer. The password can be found at `~/.vagrant.d/boxes/ubuntu-VAGRANTSLASH-xenial64/YYYYmmdd.x.x/virtualbox/Vagrantfile`.

I would rather login as the `vagrant` user with `authorized_keys`, so the provisioning script `bootstrap.sh` contains code to accomplish it.

## Ansible

### Install Ansible with Virtualenv

    $ sudo easy_install pip
    $ sudo pip install virtualenv

    # Install ansible in ~/.virtualenv/ansible
    $ mkdir ~/.virtualenv
    $ cd ~/.virtualenv
    $ virtualenv --no-site-packages ansible
    $ source ~/.virtualenv/bin/activate
    $ pip install ansible
    $ ansible --version

### Running Playbook

    $ make

    # Modify your ansible hosts
    $ vi etc/hosts
    [standalone]
    xxx.xxx.xxx.xxx

    # Modify ansible.cfg if needed
    $ vi ansible.cfg

    $ ansible-playbook playbook.yml

