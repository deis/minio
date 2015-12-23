#!/usr/bin/env bash
#
# Build and push Docker images to Docker Hub and quay.io.
#

cd "$(dirname "$0")" || exit 1


VER=v2-alpha
# note that we must check TRAVIS_PULL_REQUEST first because, for pull request builds, TRAVIS_BRANCH will contain the name of the branch that the PR is _targeting_ (not the name of the branch it is trying to merge).
# see https://docs.travis-ci.com/user/environment-variables/#Default-Environment-Variables for an explanation of TRAVIS_PULL_REQUEST and TRAVIS_BRANCH
if [[ $TRAVIS_PULL_REQUEST != "false" ]; then
  VER="pr-$TRAVIS_PULL_REQUEST"
elif  [[ $TRAVIS_BRANCH != "master" ]]; then
  VER="branch-$TRAVIS_BRANCH"
fi

export IMAGE_PREFIX=deisci VERSION=$VER
docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
DEIS_REGISTRY='' make -C .. build docker-build docker-push
docker login -e="$QUAY_EMAIL" -u="$QUAY_USERNAME" -p="$QUAY_PASSWORD" quay.io
DEIS_REGISTRY=quay.io/ make -C .. build docker-build docker-push
