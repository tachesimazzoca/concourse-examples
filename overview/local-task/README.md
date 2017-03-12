# concourse-examples/overview/local-task

This example demonstrates how to work with local files. 

    $ fly -t <target> login -c <CONCOURSE_EXTERNAL_URL>
    $ fly -t <target> execute -c build.yml

The command `execute` puts local files as `inputs` under a build directory in a container, such as `/tmp/build/<hash>`. The `<CONCOURSE_EXTERNAL_URL>`, specified as the `--external-url` option, can't be `localhost`. The loopback URL will refuse any connections for copying files using PUT method.

