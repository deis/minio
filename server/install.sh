#!/bin/bash

# This script builds the minio server (https://github.com/minio/minio) inside a Docker container. It should be run inside a golang:1.5.2 container, with the following environment variables set.
#
# - GOROOT=/usr/local/go
# - GO15VENDOREXPERIMENT=1
#
# It also expects the current directory (mc/) to be mounted at /pwd, and for /pwd to be the current working directory
#
# See the 'mc' build target in the Makefile (in the parent directory) for an example of how to use this script.

apt-get update && apt-get install -yq yasm
mkdir -p $GOPATH/src/github.com/minio
cd $GOPATH/src/github.com/minio
git clone -b master --single-branch https://github.com/minio/minio.git minio
cd minio
git reset --hard 356b889
make install
cp $GOPATH/bin/minio /pwd/minio
