# this script intended to be run inside alpine linux. see the "ssl-cert" build target in the Makefile (one directory above)

apk add --update-cache openssl
rm -rf /var/cache/apk/*

openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -subj "/C=US/ST=California/L=San Francisco/O=Engine Yard" -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
