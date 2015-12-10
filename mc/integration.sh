#!/bin/bash

# This script provides a simple integration test against the minio server (https://github.com/minio/minio).
# It uses the Minio 'mc' client (https://github.com/minio/mc) to do all its work.
#
# It's intended to be run inside a Docker container running an image built with the Dockerfile in this directory.
# The 'mc' target in the Makefile (in the parent directory) builds such an image.
# Finally, this script expects to run in a Kubernetes cluster with a Minio replication controller or pod running and a service called
# "deis-minio" running in front of running in front of it.
#
# You can launch this script by running 'make mc-integration' from the parent directory.
#
# TODO: probably rewrite this script in Go!

CERT_LOCATION="/var/run/secrets/deis/minio/ssl/access-cert"
cp $CERT_LOCATION /etc/ssl/certs/deis-minio-self-signed-cert.crt

SECRET_PREFIX="/var/run/secrets/deis/minio/user"
ACCESS_KEY_FILE="$SECRET_PREFIX/access-key-id"
ACCESS_SECRET_FILE="$SECRET_PREFIX/access-secret-key"

if [ -z "$DEIS_MINIO_SERVICE_HOST" ]; then
  echo "ERROR: no DEIS_MINIO_SERVICE_HOST env var "
  exit 1
elif [ -z "$DEIS_MINIO_SERVICE_PORT" ]; then
  echo "ERROR: no DEIS_MINIO_SERVICE_PORT env var"
  exit 1
fi

if ! [ -e $ACCESS_KEY_FILE ]; then
  echo "ERROR: no access key file found at $ACCESS_KEY_FILE"
  exit 1
elif ! [ -e $ACCESS_SECRET_FILE ]; then
  echo "ERROR: no access secret file found at $ACCESS_SECRET_FILE"
  exit 1
fi

FULL_HOST="http://$DEIS_MINIO_SERVICE_HOST:$DEIS_MINIO_SERVICE_PORT"
BUCKET=mybucket
ACCESS_KEY=`cat $ACCESS_KEY_FILE`
ACCESS_SECRET=`cat $ACCESS_SECRET_FILE`
mc config host add $FULL_HOST $ACCESS_KEY $ACCESS_SECRET

echo "mc mb $FULL_HOST/$BUCKET"
MB_OUT=$(mc mb $FULL_HOST/$BUCKET)
if [ $? -ne 0 ]; then
  echo "FAIL: exit code $?"
  exit 1
elif [ -z "$MB_OUT" ]; then
  echo "FAIL: no output"
  exit 1
fi
echo "$MB_OUT"

echo "abc" > file.txt

echo "mc cp file.txt $FULL_HOST/$BUCKET/file.txt"
CP_OUT=$(mc cp file.txt $FULL_HOST/$BUCKET/file.txt)
if [ $? -ne 0 ]; then
  echo "FAIL: exit code $?"
  exit 1
elif [ -z "$CP_OUT" ]; then
  echo "FAIL: no output"
  exit 1
fi

FILE=$(mc cat $FULL_HOST/$BUCKET/file.txt)
if [ $? -ne 0 ]; then
  echo "FAIL: exit code $?"
  exit 1
elif [ -z "$FILE" ];
  echo "FAIL: no output"
  exit 1
fi
