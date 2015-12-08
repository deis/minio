FROM golang:1.5.1-alpine

RUN apk add --update-cache curl bash make git wget && rm -rf /var/cache/apk/*

ENV GOPATH /go
ENV GOROOT /usr/local/go

RUN mkdir -p ${GOPATH}/bin
ENV PATH=${GOROOT}/bin:${GOPATH}/bin:$PATH

RUN mkdir -p ${GOPATH}/src/github.com/minio
WORKDIR ${GOPATH}/src/github.com/minio

WORKDIR ${GOPATH}/src/github.com/minio
RUN curl -L -O -s https://github.com/minio/mc/archive/master.tar.gz && tar -xvzf master.tar.gz && rm master.tar.gz && mv mc-master mc
WORKDIR ${GOPATH}/src/github.com/minio/mc
RUN make install

CMD ${GOPATH}/bin/mc
