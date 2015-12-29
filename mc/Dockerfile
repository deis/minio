FROM ubuntu-debootstrap:14.04

RUN apt-get update -y && apt-get install -y -q ca-certificates

ADD mc /bin/mc

ENV DEIS_VERSION=2.0.0-dev
ADD ./integration.sh /bin/integration.sh
RUN chmod +x /bin/integration.sh

CMD mc
