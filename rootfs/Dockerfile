FROM alpine:3.3

ENV DEIS_RELEASE=2.0.0-dev
RUN apk add -U ca-certificates
COPY . /
ENV DOCKERIMAGE=1
CMD "boot"
