DEV_REGISTRY ?= $(docker-machine ip deis):5000
DEIS_REGISTRY ?= ${DEV_REGISTRY}
IMAGE_PREFIX ?= deis
VERSION ?= git-$(shell git rev-parse --short HEAD)

MC_IMAGE := ${DEIS_REGISTRY}${IMAGE_PREFIX}/mc:${VERSION}
MC_INTEGRATION_IMAGE := ${DEIS_REGISTRY}${IMAGE_PREFIX}/mc:${VERSION}

build:
	docker run -e GO15VENDOREXPERIMENT=1 -e GOROOT=/usr/local/go --rm -v ${CURDIR}:/pwd -w /pwd golang:1.5.2 ./install.sh

docker-build:
	docker build -t ${MC_IMAGE} ${CURDIR}

docker-push:
	docker push ${MC_IMAGE}
