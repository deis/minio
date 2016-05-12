FROM alpine:3.3

RUN apk add -U ca-certificates && rm -rf /var/cache/apk/*

ADD mc /bin/mc

ENV WORKFLOW_RELEASE=2.0.0-dev
ADD ./integration/integration.sh /bin/integration.sh
RUN chmod +x /bin/integration.sh

# this is so the minio client (https://github.com/minio/mc) works properly
ENV DOCKERIMAGE=1

CMD mc
