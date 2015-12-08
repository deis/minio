# this script intended to be run inside an alpine:3.2 Docker container, inside a /bin/ash shell.
# it expects that its parent directory (minio/) is mounted to this container and also is its current working directory.

apk add --update-cache openssl
rm -rf /var/cache/apk/*

# these commands are adapted from the very clear and extensive Heroku documents on creating a self-signed SSL certificate: https://devcenter.heroku.com/articles/ssl-certificate-self#generate-private-key-and-certificate-signing-request

openssl genrsa -des3 -passout pass:x -out ./genssl/server.pass.key 2048
openssl rsa -passin pass:x -in ./genssl/server.pass.key -out ./genssl/server.key
rm ./genssl/server.pass.key
openssl req -new -key ./genssl/server.key -subj "/C=US/ST=California/L=San Francisco/O=Engine Yard" -out ./genssl/server.csr
# generate the cert
openssl x509 -req -days 365 -in ./genssl/server.csr -signkey ./genssl/server.key -out ./genssl/server.cert
