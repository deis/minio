SHORT_NAME := minio

export GO15VENDOREXPERIMENT=1

# dockerized development environment variables
REPO_PATH := github.com/deis/${SHORT_NAME}
DEV_ENV_IMAGE := quay.io/deis/go-dev:0.5.0
DEV_ENV_WORK_DIR := /go/src/${REPO_PATH}
DEV_ENV_PREFIX := docker run --rm -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR}
DEV_ENV_CMD := ${DEV_ENV_PREFIX} ${DEV_ENV_IMAGE}

VERSION ?= git-$(shell git rev-parse --short HEAD)
LDFLAGS := "-s -X main.version=${VERSION}"
BINDIR := ./rootfs/bin
DEV_REGISTRY ?= $(docker-machine ip deis):5000
DEIS_REGISTRY ?= ${DEV_REGISTRY}

ENVTPL_PREFIX := docker run --rm -v ${CURDIR}:/pwd -w /pwd
ENVTPL_IMAGE := quay.io/arschles/envtpl:0.0.1

IMAGE_PREFIX ?= deis

NAMESPACE ?= deis
RC := manifests/deis-${SHORT_NAME}-rc.tpl.yaml
SVC := manifests/deis-${SHORT_NAME}-service.tpl.yaml
ADMIN_SEC := manifests/deis-${SHORT_NAME}-secretAdmin.tpl.yaml
USER_SEC := manifests/deis-${SHORT_NAME}-secretUser.tpl.yaml
MC_POD := manifests/deis-mc-pod.tpl.yaml
MC_INTEGRATION_POD := manifests/deis-mc-integration-pod.tpl.yaml
# note that we are not running minio with ssl turned on. this variable is commented
# SSL_SEC := manifests/deis-${SHORT_NAME}-secretssl-final.yaml
IMAGE := ${DEIS_REGISTRY}${IMAGE_PREFIX}/${SHORT_NAME}:${VERSION}
MC_IMAGE := ${DEIS_REGISTRY}${IMAGE_PREFIX}/mc:${VERSION}
MC_INTEGRATION_IMAGE := ${DEIS_REGISTRY}${IMAGE_PREFIX}/mc-integration:${VERSION}

TEST_PACKAGES := $(shell ${DEV_ENV_CMD} glide nv)

all: build docker-build docker-push

bootstrap:
	${DEV_ENV_CMD} glide install

glideup:
	${DEV_ENV_CMD} glide up

build:
	mkdir -p ${BINDIR}
	${DEV_ENV_PREFIX} -e CGO_ENABLED=0 ${DEV_ENV_IMAGE} go build -a -installsuffix cgo -ldflags '-s' -o $(BINDIR)/boot boot.go || exit 1

test:
	${DEV_ENV_CMD} go test ${TEST_PACKAGES}

docker-build: build-server
	# copy the server binary from where it was built to the final image's file system.
	# note that the minio server is built as a dependency of this build target.
	cp server/minio ${BINDIR}

	# build the main image
	docker build --rm -t ${IMAGE} rootfs
	# These are both YAML specific
	perl -pi -e "s|image: [a-z0-9.:]+\/deis\/${SHORT_NAME}:[0-9a-z-.]+|image: ${IMAGE}|g" ${RC}
	perl -pi -e "s|release: [a-zA-Z0-9.+_-]+|release: ${VERSION}|g" ${RC}

docker-push:
	docker push ${IMAGE}

deploy: build docker-build docker-push kube-rc

# TODO: would be nice to refactor all of this code into a single binary. 1/2 of it is already written in genssl/manifest_replace.go.
# the other 1/2 is in gen.sh, and should be refactored as a few 'exec.Command' calls...
#
# NOTE: that we are not currently running the minio server with ssl turned on. this target is currently not used
ssl-cert:
	# generate ssl certs
	docker run --rm -v "${CURDIR}":/pwd -w /pwd centurylink/openssl:0.0.1 ./genssl/gen.sh
	# replace values in ssl secrets file
	docker run --rm -v "${CURDIR}":/pwd -w /pwd golang:1.5.1-alpine go run ./genssl/manifest_replace.go --cert=./genssl/server.cert --key=./genssl/server.key --tpl=./manifests/deis-minio-secretssl-tpl.yaml --out=./manifests/deis-minio-secretssl-final.yaml

kube-rc:
	${ENVTPL_PREFIX} -e RC_NAMESPACE=${NAMESPACE} -e RC_IMAGE=${IMAGE} ${ENVTPL_IMAGE} envtpl -in=${RC} | kubectl create -f -

# note that we are not running minio with ssl turned on. the ssl related dependency and commands are commented out in this target
kube-secrets: #ssl-cert
	${ENVTPL_PREFIX} -e SECRET_NAMESPACE=${NAMESPACE} ${ENVTPL_IMAGE} envtpl -in=${ADMIN_SEC} | kubectl create -f -
	${ENVTPL_PREFIX} -e SECRET_NAMESPACE=${NAMESPACE} ${ENVTPL_IMAGE} envtpl -in=${USER_SEC} | kubectl create -f -
	# kubectl create -f ${SSL_SEC}

# note that we are not running minio with ssl turned on. the ssl related dependency and commands are commented out in this target
kube-clean-secrets:
	kubectl delete secret minio-user
	kubectl delete secret minio-admin
	# kubectl delete secret minio-ssl

kube-service: kube-secrets
	${ENVTPL_PREFIX} -e SVC_NAMESPACE=${NAMESPACE} ${ENVTPL_IMAGE} envtpl -in=${SVC} | kubectl create -f -
	${ENVTPL_PREFIX} -e SECRET_NAMESPACE=${NAMESPACE} ${ENVTPL_IMAGE} envtpl -in=${USER_SEC} | kubectl create -f -

kube-clean:
	kubectl delete rc deis-${SHORT_NAME}-rc

kube-mc:
	${ENVTPL_PREFIX} -e POD_NAMESPACE=${NAMESPACE} -e POD_IMAGE=${MC_IMAGE} ${ENVTPL_IMAGE} envtpl -in=${MC_POD} | kubectl create -f -

kube-mc-integration:
	${ENVTPL_PREFIX} -e POD_NAMESPACE=${NAMESPACE} -e POD_IMAGE=${MC_INTEGRATION_IMAGE} envtpl -in=${MC_INTEGRATION_POD} | kubectl create -f -

# build the minio server
build-server:
	docker run -e GO15VENDOREXPERIMENT=1 -e GOROOT=/usr/local/go --rm -v "${CURDIR}/server":/pwd -w /pwd golang:1.6 ./install.sh

mc-build:
	make -C mc build

mc-docker-build:
	make -C mc docker-build

mc-docker-push:
	make -C mc docker-push

# targets for the mc integration tests

mc-integration-docker-build:
	make -C mc/integration docker-build

mc-integration-docker-push:
	make -C mc/integration docker-push

.PHONY: all build docker-compile kube-up kube-down deploy mc kube-mc
