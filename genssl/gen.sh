# this script intended to be run inside an alpine:3.2 Docker container, inside a /bin/ash shell.
# it expects that its parent directory is a volume mounted at /pwd and its current working directory is /pwd also

apk add --update-cache openssl
rm -rf /var/cache/apk/*

mkdir -p ./rootfs/certs
cd ./rootfs/certs

openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -subj "/C=US/ST=California/L=San Francisco/O=Engine Yard" -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
