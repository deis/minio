FROM ubuntu-debootstrap:14.04

ENV GOLANG_TARBALL go1.5.1.linux-amd64.tar.gz

ENV GOROOT /usr/local/go/
ENV GOPATH /go
ENV PATH ${GOROOT}/bin:${GOPATH}/bin/:$PATH

ENV MINIOHOME /home/minio
ENV MINIOUSER minio
RUN useradd -m -d $MINIOHOME $MINIOUSER

RUN apt-get update -y && apt-get install -y -q \
		curl \
		git \
		build-essential \
		ca-certificates \
		yasm

RUN curl -O -s https://storage.googleapis.com/golang/${GOLANG_TARBALL} && \
		tar -xzf ${GOLANG_TARBALL} -C ${GOROOT%*go*} && \
		rm ${GOLANG_TARBALL}

RUN mkdir -p ${GOPATH}/src/github.com/minio
WORKDIR ${GOPATH}/src/github.com/minio
RUN curl -fsSL https://github.com/minio/minio/archive/master.tar.gz | tar -zx
RUN mv minio-master minio
WORKDIR ${GOPATH}/src/github.com/minio/minio
RUN ls -l
RUN make
CMD ["cp", "/go/bin/minio", "/app"]
