FROM ubuntu-debootstrap:14.04

RUN apt-get update -y && apt-get install -y -q ca-certificates

ADD mc /bin/mc

ENV DEIS_RELEASE=2.0.0-dev
ADD ./integration/integration.sh /bin/integration.sh
RUN chmod +x /bin/integration.sh

# this is so the minio client (https://github.com/minio/mc) works properly
ENV DOCKERIMAGE=1

CMD mc
