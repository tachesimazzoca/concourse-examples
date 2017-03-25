#!/bin/sh

set -e -x

# Print current directory in a container
pwd

# List up files sent from inputs (this working directory)
find local-task
