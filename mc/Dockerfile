FROM ubuntu-debootstrap:14.04

RUN apt-get update -y && apt-get install -y -q ca-certificates

ADD mc /bin/mc

ADD ./integration.sh /bin/integration.sh
RUN chmod +x /bin/integration.sh

CMD mc
