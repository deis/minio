FROM ubuntu:14.04

ENV MINIOHOME /home/minio
ENV MINIOUSER minio
ENV DEIS_RELEASE=2.0.0-dev
RUN useradd -m -d $MINIOHOME $MINIOUSER
RUN apt-get update -y && apt-get install -y -q ca-certificates curl
RUN curl -f -SL https://dl.minio.io:9000/updates/2015/Sept/linux-amd64/mc -o /usr/bin/mc
RUN chmod 755 /usr/bin/mc
COPY . /
USER minio
RUN mkdir /home/minio/.minio
CMD "boot"
