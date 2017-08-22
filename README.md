
|![](https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Warning.svg/156px-Warning.svg.png) | Deis Workflow will soon no longer be maintained.<br />Please [read the announcement](https://deis.com/blog/2017/deis-workflow-final-release/) for more detail. |
|---:|---|
| 09/07/2017 | Deis Workflow [v2.18][] final release before entering maintenance mode |
| 03/01/2018 | End of Workflow maintenance: critical patches no longer merged |

# Deis Minio v2

[![Build Status](https://ci.deis.io/job/minio/badge/icon)](https://ci.deis.io/job/minio)
[![Go Report Card](http://goreportcard.com/badge/deis/minio)](http://goreportcard.com/report/deis/minio)
[![Docker Repository on Quay](https://quay.io/repository/deisci/minio/status "Docker Repository on Quay")](https://quay.io/repository/deisci/minio)

Deis (pronounced DAY-iss) Workflow is an open source Platform as a Service (PaaS) that adds a developer-friendly layer to any [Kubernetes](http://kubernetes.io) cluster, making it easy to deploy and manage applications on your own servers.

For more information about the Deis workflow, please visit the main project page at https://github.com/deis/workflow.

We welcome your input! If you have feedback, please submit an [issue][issues]. If you'd like to participate in development, please read the "Development" section below and submit a [pull request][prs].

# About

The Deis minio component provides an [S3 API][s3-api] compatible object storage server, based on [Minio](http://minio.io), that can be run on Kubernetes. It's intended for use within the [Deis v2 platform][deis-docs] as an object storage server, but it's flexible enough to be run as a standalone pod on any Kubernetes cluster.

Note that in the default [Helm chart for the Deis platform](https://github.com/deis/charts/tree/master/deis-dev), this component is used as a storage location for the following components:

- [deis/postgres](https://github.com/deis/postgres)
- [deis/registry](https://github.com/deis/registry)
- [deis/builder](https://github.com/deis/builder)

Also note that we aren't currently providing this component with any kind of persistent storage, but it may work with [persistent volumes](http://kubernetes.io/docs/user-guide/volumes/).

# Development

The Deis project welcomes contributions from all developers. The high level process for development matches many other open source projects. See below for an outline.

* Fork this repository
* Make your changes
* Submit a [pull request][prs] (PR) to this repository with your changes, and unit tests whenever possible.
* If your PR fixes any [issues][issues], make sure you write Fixes #1234 in your PR description (where #1234 is the number of the issue you're closing)
* The Deis core contributors will review your code. After each of them sign off on your code, they'll label your PR with `LGTM1` and `LGTM2` (respectively). Once that happens, you may merge.

## Minio Binary Mirror

Also, note that the [Dockerfile](rootfs/Dockerfile) uses an `ADD` directive to download pre-built Minio binaries from a [Google Cloud Storage bucket](https://console.cloud.google.com/storage/browser/minio-mirror/?project=deis-mirrors). The bucket is in the `deis-mirrors` project, and if you have access to that project, [this link](https://console.cloud.google.com/storage/browser/minio-mirror/?project=deis-mirrors) should take you directly to that bucket.

To bump this component to use a newer build of Minio, simply add a new binary to the bucket (under the `linux-amd64` folder), check the checkbox under the `Share publicly` column, and update the URL in the `ADD` directive in the aforementioned `Dockerfile`.

## Docker Based Development Environment

The preferred environment for development uses the [`go-dev` Docker image](https://github.com/deis/docker-go-dev). The tools described in this section are used to build, test, package and release each version of Deis.

To use it yourself, you must have [make](https://www.gnu.org/software/make/) installed and Docker installed and running on your local development machine.

If you don't have Docker installed, please go to https://www.docker.com/ to install it.

After you have those dependencies, build your code with `make build` and execute unit tests with `make test`.

## Native Go Development Environment

You can also use the standard go toolchain to build and test if you prefer. To do so, you'll need [glide](https://github.com/Masterminds/glide) 0.9 or above and [Go](http://golang.org/) 1.6 or above installed.

After you have those dependencies, you can build and unit-test your code with `go build` and `go test $(glide nv)`, respectively.

Note that you will not be able to build or push Docker images using this method of development.


## Testing

The Deis project requires that as much code as possible is unit tested, but the core contributors also recognize that some code must be tested at a higher level (functional or integration tests, for example).

The [end-to-end tests](https://github.com/deis/workflow-e2e) repository has our integration tests. Additionally, the core contributors and members of the community also regularly [dogfood](https://en.wikipedia.org/wiki/Eating_your_own_dog_food) the platform.

## Running End-to-End Tests

Please see [README.md](https://github.com/deis/workflow-e2e/blob/master/README.md) on the end-to-end tests reposotory for instructions on how to set up your testing environment and run the tests.

## Dogfooding

Please follow the instructions on the [official Deis docs][deis-docs] to install and configure your Deis cluster and all related tools, and deploy and configure an app on Deis.


[install-k8s]: http://kubernetes.io/gettingstarted/
[s3-api]: http://docs.aws.amazon.com/AmazonS3/latest/API/APIRest.html
[issues]: https://github.com/deis/minio/issues
[prs]: https://github.com/deis/minio/pulls
[deis-docs]: https://deis.com/docs/workflow
[v2.18]: https://github.com/deis/workflow/releases/tag/v2.18.0
