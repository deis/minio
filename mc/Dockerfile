FROM golang:1.5

WORKDIR /go/src/github.com/minio
RUN git clone https://github.com/minio/minio
WORKDIR /go/src/github.com/minio/minio
ENV GOPATH /go
ENV GOROOT /usr/local/go
RUN make install
