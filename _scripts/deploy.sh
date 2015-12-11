#!/usr/bin/env bash
#
# Build and push Docker images to Docker Hub and quay.io.
#

cd "$(dirname "$0")" || exit 1

BRANCH=$(git symbolic-ref --short -q HEAD)

VER=v2-alpha
if ![ $BRANCH == "master" ]; then
  # deploy to "test-$BRANCH" tag if on a branch
  VER="test-$BRANCH"
fi

export IMAGE_PREFIX=deisci VERSION=$VER
docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
DEIS_REGISTRY='' make -C .. build docker-build docker-push
docker login -e="$QUAY_EMAIL" -u="$QUAY_USERNAME" -p="$QUAY_PASSWORD" quay.io
DEIS_REGISTRY=quay.io/ make -C .. build docker-build docker-push
