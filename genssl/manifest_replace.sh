#!/bin/ash
# this script intended to be run inside an alpine:3.2 Docker container, inside a /bin/ash shell.
# it expects that its parent directory (minio/) is mounted to this container and also is its current working directory.
# finally, it also expects that a 'server.cert' and 'server.key' in ./genssl. it uses those as the SSL cert and private key (AKA .pem) files, respectively

CERT=$(base64 ./genssl/server.cert | tr -d '\n')
PEM=$(base64 ./genssl/server.key | tr -d '\n')

FINAL_FILE=./manifests/deis-minio-secretssl-final.yaml

FILE_CONTENTS=$(sed -e "s/ACCESS_CERT/$CERT/" ./manifests/deis-minio-secretssl.yaml)
echo "$FILE_CONTENTS" > $FINAL_FILE
FILE_CONTENTS=$(sed -e "s/ACCESS_PEM/$PEM/" $FINAL_FILE)
echo "$FILE_CONTENTS" > $FINAL_FILE
