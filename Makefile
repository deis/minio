SHORT_NAME := minio

export GO15VENDOREXPERIMENT=1

# Note that Minio currently uses CGO.

VERSION := 0.0.1-$(shell date "+%Y%m%d%H%M%S")
LDFLAGS := "-s -X main.version=${VERSION}"
BINDIR := ./rootfs/bin
DEV_REGISTRY ?= $(eval docker-machine ip deis):5000
DEIS_REGISTRY ?= ${DEV_REGISTRY}

RC := manifests/deis-${SHORT_NAME}-rc.yaml
SVC := manifests/deis-${SHORT_NAME}-service.yaml
SEC := manifests/deis-${SHORT_NAME}-secret.yaml
IMAGE := ${DEIS_REGISTRY}/deis/${SHORT_NAME}:${VERSION}

all: build docker-build docker-push

build:
	mkdir -p ${BINDIR}/bin
	docker build --rm -t deis/minio-builder:0 .
	sleep 3
	docker cp $(shell docker run -d -v rootfs/bin:/app -w /go/src/github.com/minio/minio deis/minio-builder:0 sleep 20):/go/bin/minio rootfs/bin

docker-build:
	docker build --rm -t ${IMAGE} rootfs
	# These are both YAML specific
	perl -pi -e "s|image: [a-z0-9.:]+\/deis\/${SHORT_NAME}:[0-9a-z-.]+|image: ${IMAGE}|g" ${RC}
	perl -pi -e "s|release: [a-zA-Z0-9.+_-]+|release: ${VERSION}|g" ${RC}

docker-push:
	docker push ${IMAGE}

deploy: kube-service kube-rc
	kubectl create -f ${SVC}

kube-rc:
	kubectl create -f ${RC}

kube-secrets:
	- kubectl create -f ${SEC}

kube-service: kube-secrets
	- kubectl create -f ${SVC}

kube-clean:
	- kubectl delete rc deis-${SHORT_NAME}-rc

kube-mc:
	kubectl create -f manifests/deis-mc-pod.yaml

mc:
	docker build -t ${DEIS_REGISTRY}/deis/minio-mc:latest mc
	docker push ${DEIS_REGISTRY}/deis/minio-mc:latest
	perl -pi -e "s|image: [a-z0-9.:]+\/|image: ${DEIS_REGISTRY}/|g" manifests/deis-mc-pod.yaml


.PHONY: all build docker-compile kube-up kube-down deploy mc kube-mc
