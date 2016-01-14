FROM alpine:3.3

ENV MINIOHOME /home/minio
ENV MINIOUSER minio
ENV DEIS_RELEASE=2.0.0-dev
RUN adduser -D -h $MINIOHOME $MINIOUSER
RUN apk add -U ca-certificates yasm curl && rm -rf /var/cache/apk/*
COPY . /
USER minio
RUN mkdir /home/minio/.minio
ENTRYPOINT ["boot"]
