DEV_REGISTRY ?= $(docker-machine ip deis):5000
DEIS_REGISTRY ?= ${DEV_REGISTRY}
IMAGE_PREFIX ?= deis
VERSION ?= git-$(shell git rev-parse --short HEAD)

IMAGE := ${DEIS_REGISTRY}${IMAGE_PREFIX}/mc-integration:${VERSION}

docker-build:
	docker build -t ${IMAGE} ${CURDIR}/..

docker-push:
	docker push ${IMAGE}
