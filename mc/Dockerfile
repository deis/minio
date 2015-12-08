FROM ubuntu-debootstrap:14.04

RUN apt-get update -y && apt-get install -y -q ca-certificates

ADD mc /bin/mc

CMD mc
