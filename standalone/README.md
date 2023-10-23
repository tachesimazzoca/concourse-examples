# Setup Concourse in a standalone host

## Debian with Vagrant

Concourse standalone binary requires Linux kernel 4.19+ and PostgreSQL 9.3+. This examples uses [debian/bullseye64](https://app.vagrantup.com/debian/boxes/bullseye64) as a base box.

    $ make

    # Modify your private ip
    $ vi Vagrantfile
    ...
    config.vm.network "private_network", ip: "xxx.xxx.xxx.xxx"

    $ vagrant up

## Chef

    $ cp chef-repo/skel/localhost.json chef-repo/

    # modify attributes
    $ vi chef-repo/localhost.json
    ...
      "docker": {
        "registry_url": "192.168.33.151",
        "registry_port": "5000"
      },
      "concourse_web": {
        "add_local_user": "admin:changeme",
        "main_team_local_user": "admin",
        "external_url": "http://192.168.33.151:8080",
        "postgres_host": "localhost",
        "postgres_port": "5432",
        "postgres_user": "concourse",
        "postgres_database": "concourse",
        "postgres_sslmode": "disable"
      },
    ...

    $ rsync -avz --delete --excludes=/nodes/ chef-repo/ your-concourse-standalone:/path/to/chef-repo/
    $ ssh your-concourse-standalone
    $ cd /path/to/chef-repo
    $ sudo chef-client -z -N localhost -j localhost.json

