SHORT_NAME := minio

export GO15VENDOREXPERIMENT=1

# dockerized development environment variables
REPO_PATH := github.com/deis/${SHORT_NAME}
DEV_ENV_IMAGE := quay.io/deis/go-dev:0.9.1
DEV_ENV_WORK_DIR := /go/src/${REPO_PATH}
DEV_ENV_PREFIX := docker run --rm -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR}
DEV_ENV_CMD := ${DEV_ENV_PREFIX} ${DEV_ENV_IMAGE}

LDFLAGS := "-s -X main.version=${VERSION}"
BINDIR := ./rootfs/bin
DEV_REGISTRY ?= $(docker-machine ip deis):5000
DEIS_REGISTRY ?= ${DEV_REGISTRY}

IMAGE_PREFIX ?= deis

include versioning.mk

TEST_PACKAGES := $(shell ${DEV_ENV_CMD} glide nv)

all: build docker-build docker-push

bootstrap:
	${DEV_ENV_CMD} glide install

glideup:
	${DEV_ENV_CMD} glide up

build:
	mkdir -p ${BINDIR}
	${DEV_ENV_CMD} go build -ldflags '-s' -o $(BINDIR)/boot boot.go || exit 1

test:
	${DEV_ENV_CMD} go test ${TEST_PACKAGES}

docker-build: build

	# build the main image
	docker build --rm -t ${IMAGE} rootfs
	docker tag -f ${IMAGE} ${MUTABLE_IMAGE}


deploy: build docker-build docker-push

.PHONY: all bootstrap glideup build test docker-build deploy build-server
