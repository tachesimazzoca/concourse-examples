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

## pipeline

### hello

    $ fly -t <target> pipelines

    $ fly -t <target> set-pipeline -c pipeline-hello.yml -l hello-message.yml -p hello
    $ fly -t <target> unpause-pipeline -p hello
    $ fly -t <target> trigger-job -j hello/hello-world -w

    $ fly -t <target> destroy-pipeline -p hello
    $ fly -t <target> pipelines

### timer

    $ fly -t <target> set-pipeline -c pipeline-timer.yml -p timer
    $ fly -t <target> unpause-pipeline -p timer

    # Watching builds
    $ fly -t <target> watch -j timer/current-date
    $ fly -t <target> builds | grep timer/current-date

    # To stop triggering, pause the time resource
    $ fly -t <target> pause-resource -r timer/every-1m
    # or pause the pipeline
    $ fly -t <target> pause-pipeline -p timer

