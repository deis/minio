#!/bin/bash

# This script builds the minio server (https://github.com/minio/minio) inside a Docker container. It should be run inside a golang:1.5.2 container, with the following environment variables set.
#
# - GOROOT=/usr/local/go
# - GO15VENDOREXPERIMENT=1
#
# It also expects the current directory (mc/) to be mounted at /pwd, and for /pwd to be the current working directory
#
# See the 'mc' build target in the Makefile (in the parent directory) for an example of how to use this script.

mkdir -p $GOPATH/src/github.com/minio
cd $GOPATH/src/github.com/minio
curl -L -O -s https://github.com/minio/minio/archive/master.tar.gz && tar -xvzf master.tar.gz && rm master.tar.gz && mv minio-master minio
cd minio
make
cp $GOPATH/bin/minio /pwd/minio
