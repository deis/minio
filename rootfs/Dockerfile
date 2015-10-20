FROM ubuntu-debootstrap:14.04

ENV MINIOHOME /home/minio
ENV MINIOUSER minio
RUN useradd -m -d $MINIOHOME $MINIOUSER

RUN apt-get update -y && apt-get install -y -q \
		ca-certificates \
		yasm

COPY . /

USER minio
RUN mkdir /home/minio/.minio
CMD ["/bin/minio", "server"]
