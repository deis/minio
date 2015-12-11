# Deis Minio v2

[![Build Status](https://travis-ci.org/deis/minio.svg?branch=master)](https://travis-ci.org/deis/minio) [![Go Report Card](http://goreportcard.com/badge/deis/minio)](http://goreportcard.com/report/deis/minio)

Deis (pronounced DAY-iss) is an open source PaaS that makes it easy to deploy and manage
applications on your own servers. Deis builds on [Kubernetes](http://kubernetes.io/) to provide
a lightweight, [Heroku-inspired](http://heroku.com) workflow.

## Work in Progress

![Deis Graphic](https://s3-us-west-2.amazonaws.com/get-deis/deis-graphic-small.png)

Deis Minio v2 is changing quickly. Your feedback and participation are more than welcome, but be
aware that this project is considered a work in progress.

# About

This package provides a [Minio](http://minio.io) S3-compatible object storage system on Kubernetes. It can be used as a [Deis](https://deis.com/) component to provide object storage for various other components, but it is flexible enough to be run anywhere else.

We provide it as a Docker container, and also provide the following manifests to run it inside [Kubernetes](http://kubernetes.io/):

- A [replication controller](http://kubernetes.io/v1.1/docs/user-guide/replication-controller.html) to run a server on a single pod
- A [service](http://kubernetes.io/v1.1/docs/user-guide/services.html) to run in front of the replication controller
- [Secret](http://kubernetes.io/v1.1/docs/user-guide/secrets.html)s for:
  - User credentials
  - Admin credentials
  - SSL (note that the current version does not run with SSL enabled, however)

Note: this component currently does not offer persistent storage from the Docker container.

# Hacking Minio

First, install [helm](http://helm.sh) and [boot up a kubernetes cluster][install-k8s]. Next, add the
`deis` repository to your chart list:

```console
$ helm repo add deis https://github.com/deis/charts
```

Then, install the Deis chart!

```console
$ helm install deis/deis
```

The chart will install the entire Deis platform onto Kubernetes. You can monitor all the pods that it installs by running:

```console
$ kubectl get pods --namespace=deis
```

Once this is done, SSH into a Kubernetes minion, and run the following:

```
$ curl -sSL http://deis.io/deis-cli/install.sh | sh
$ sudo mv deis /bin
$ kubectl get service deis-workflow
$ deis register 10.247.59.157 # or the appropriate CLUSTER_IP
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
$ eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa
$ deis keys:add ~/.ssh/id_rsa.pub
$ deis create --no-remote
Creating Application... done, created madras-radiator
$ deis pull deis/example-go -a madras-radiator
Creating build... ..o
```

If you want to hack on a new feature, build the deis/minio image and push it to a Docker registry. The `$DEIS_REGISTRY` environment variable must point to a registry accessible to your Kubernetes cluster. If you're using a locally hosted Docker registry, you may need to configure the Docker engines on your Kubernetes nodes to allow `--insecure-registry 192.168.0.0/16` (or the appropriate address range).

```console
$ make docker-push
```

Next, you'll want to remove the `deis-minio` [replication controller](http://kubernetes.io/v1.1/docs/user-guide/replication-controller.html) and re-create it to run your new image.

```console
make kube-rc
```

## Installation

The following steps assume that you have the [Docker CLI](https://docs.docker.com/) and [Kubernetes CLI](http://kubernetes.io/v1.1/docs/user-guide/kubectl-overview.html) installed and correctly configured.

```
make deploy kube-service
```

## License

Copyright 2013, 2014, 2015 Engine Yard, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


[install-k8s]: http://kubernetes.io/gettingstarted/
