# Overview

## login

    $ fly -t <target> login -c <CONCOURSE_EXTERNAL_URL>

The `<CONCOURSE_EXTERNAL_URL>`, specified as the `--external-url` option, can't be `localhost`. The loopback URL will refuse any connections for copying files using PUT method.

That command will store a credential information at `~/.flyrc`. It doesn't mean that you log in to the concouse-web UI.

    $ cat ~/.flyrc
    targets:
      <target>:
        api: <CONCOURSE_EXTERNAL_URL>
        team: main
        token:
          type: Bearer
          value: ...

## execute

You can execute any tasks without setting pipelines.

    $ fly -t <target> execute -c task-hello.yml
    $ fly -t <target> execute -c task-sh.yml

The command `execute` puts local files under the `inputs` into a build directory in a container, such as `/tmp/build/<hash>`.

    $ cat task-local.yml
    ...
    inputs:
    - name: overview

    $ fly -t <target> execute -c task-local.yml

