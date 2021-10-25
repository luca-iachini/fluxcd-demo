#!/usr/bin/env bash

set -eo xtrace


# check if input params are defined
[[ -z "$1" ]] && { echo "Please provide package!"; exit 1; }
[[ -z "$2" ]] && { echo "Please provide version!"; exit 1; }

export PACKAGE=$1
export VERSION=$2

if [ ! -d "go/$PACKAGE" ]; then
  echo 'Provided package name is not correct!'; exit 1;
fi


export PROJECT="fluxcd-test"
export REGISTRY=$DOCKER_REG_HOST:$DOCKER_REG_PORT
export REPOSITORY="${PROJECT}/${PACKAGE}"

echo "Building docker"

docker login -u $DOCKER_REG_USER -p $DOCKER_REG_PASSWORD $REGISTRY

# Enable BuildKit builds
export DOCKER_BUILDKIT=1

# Build image
docker build . \
  --file docker/Dockerfile \
  --build-arg package=$PACKAGE \
  --tag ${REGISTRY}/${REPOSITORY}:${VERSION} \
  --progress=plain


# Push images to registry
docker push ${REGISTRY}/${REPOSITORY}:${VERSION}