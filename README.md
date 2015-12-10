# Deis Minio

[![Build Status](https://travis-ci.org/deis/minio.svg?branch=master)](https://travis-ci.org/deis/minio) [![Go Report Card](http://goreportcard.com/badge/deis/minio)](http://goreportcard.com/report/deis/minio)


This package provides a [Minio](http://minio.io) S3-compatible object storage system on Kubernetes. It can be used as a [Deis](https://deis.com/) component to provide object storage for various other components, but it is flexible enough to be run anywhere else.

We provide it as a Docker container, and also provide the following manifests to run it inside [Kubernetes](http://kubernetes.io/):

- A [replication controller](http://kubernetes.io/v1.1/docs/user-guide/replication-controller.html) to run a server on a single pod
- A [service](http://kubernetes.io/v1.1/docs/user-guide/services.html) to run in front of the replication controller
- [Secret](http://kubernetes.io/v1.1/docs/user-guide/secrets.html)s for:
  - User credentials
  - Admin credentials
  - SSL

Note: this component currently does not offer persistent storage from the Docker container.

## Installation

The following steps assume that you have the [Docker CLI](https://docs.docker.com/) and [Kubernetes CLI](http://kubernetes.io/v1.1/docs/user-guide/kubectl-overview.html) installed and correctly configured.

```
make deploy kube-service
```
