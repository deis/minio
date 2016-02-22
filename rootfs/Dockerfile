FROM ubuntu:14.04

ENV MINIOHOME /home/minio
ENV MINIOUSER minio
ENV DEIS_RELEASE=2.0.0-dev
RUN useradd -m -d $MINIOHOME $MINIOUSER && \
    apt-get update -y && \
    apt-get install -y -q ca-certificates curl && \
    curl -f -SL https://dl.minio.io:9000/updates/2015/Sept/linux-amd64/mc -o /usr/bin/mc && \
    chmod 755 /usr/bin/mc && \
    curl -f -SL https://dl.minio.io/server/minio/release/linux-amd64/minio.OFFICIAL.2016-02-08T00-12-28Z -o /bin/minio
COPY . /
USER minio
RUN mkdir /home/minio/.minio
CMD "boot"
