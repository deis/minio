FROM ubuntu-debootstrap:14.04

ENV MINIOHOME /home/minio
ENV MINIOUSER minio
RUN useradd -m -d $MINIOHOME $MINIOUSER
# this is so the minio client (https://github.com/minio/mc) works properly
ENV DOCKERIMAGE=1

RUN apt-get update -y && apt-get install -y -q \
		ca-certificates \
		yasm
RUN apt-get update -y && apt-get install -y -q curl
RUN curl -f -SL https://dl.minio.io:9000/updates/2015/Sept/linux-amd64/mc -o /usr/bin/mc
RUN chmod 755 /usr/bin/mc
COPY . /
USER minio
RUN mkdir /home/minio/.minio
ENTRYPOINT ["boot"]
