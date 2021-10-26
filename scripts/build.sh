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
export REPOSITORY="${PROJECT}/${PACKAGE}"

echo "Building docker"

docker login -u $DOCKER_REG_USER -p $DOCKER_REG_PASSWORD $DOCKER_REG_URL

# Enable BuildKit builds
export DOCKER_BUILDKIT=1

export GIT_SHA=$(git rev-parse HEAD)
export GIT_BRANCH="main"

DEV_VERSION=${GIT_BRANCH}-${GIT_SHA:0:7}-$(date +%s)

# Build image
docker build . \
  --file docker/Dockerfile \
  --build-arg package=$PACKAGE \
  --tag ${DOCKER_REG_URL}/${REPOSITORY}:${VERSION} \
  --tag ${DOCKER_REG_URL}/${REPOSITORY}:${DEV_VERSION} \
  --progress=plain


# Push images to registry
docker push ${DOCKER_REG_URL}/${REPOSITORY}:${VERSION}
docker push ${DOCKER_REG_URL}/${REPOSITORY}:${DEV_VERSION}