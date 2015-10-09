FROM ubuntu-debootstrap:14.04

ENV MINIOHOME /home/minio
ENV MINIOUSER minio
RUN useradd -m -d $MINIOHOME $MINIOUSER

RUN apt-get update -y && apt-get install -y -q \
		ca-certificates \
		yasm

COPY . /

CMD ["/bin/minio", "server"]
