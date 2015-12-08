# this script intended to be run inside an alpine:3.2 Docker container, inside a /bin/ash shell.
# it expects that its parent directory (minio/) is mounted to this container and also is its current working directory.
# finally, it also expects that a 'server.cert' and 'server.pem' in ./genssl. it uses those as the SSL cert and PEM files, respectively

FILE_CONTENTS="$(cat ./manifests/deis-minio-secretssl.yaml)"
CERT=`base64 ./genssl/server.cert`
PEM=`base64 ./genssl/server.pem`

FILE_CONTENTS="${FILE_CONTENTS/ACCESS_CERT/$CERT}"
FILE_CONTENTS="${FILE_CONTENTS/ACCESS_PEM/$PEM}"
echo $FILE_CONTENTS > ./manifests/deis-minio-secretssl-final.yaml
