#!/bin/bash

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin $DOCKER_HOSTNAME

HEAD_SHA=$(git rev-parse --short HEAD)

IMAGE_TAG=$DOCKER_HOSTNAME/$DOCKER_REPO
LATEST_TAG=$IMAGE_TAG:$TRAVIS_BRANCH-latest
VERSIONED_TAG=$IMAGE_TAG:$TRAVIS_BRANCH-$HEAD_SHA

docker pull $LATEST_TAG || true
docker build --cache-from $LATEST_TAG -t $VERSIONED_TAG . || exit 1

docker build --cache-from $LATEST_TAG \
  --tag $VERSIONED_TAG \
  --build-arg github_token="$GITHUB_TOKEN" \
  --build-arg github_org="$GITHUB_ORG" \
  --build-arg host_keys="$HOST_KEYS" . || exit 1

docker push $VERSIONED_TAG || exit 1
docker tag $VERSIONED_TAG $LATEST_TAG
docker push $LATEST_TAG
