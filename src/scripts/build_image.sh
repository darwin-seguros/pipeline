#!/bin/sh
BUILD_IMAGE_IMAGE_NAME="$(echo "${BUILD_IMAGE_IMAGE_NAME}" | circleci env subst)"
BUILD_IMAGE_IMAGE_TAG="$(echo "${BUILD_IMAGE_IMAGE_TAG}" | circleci env subst)"

cat "$(npm config get userconfig)" >> .npmrc
echo "Building docker image with identification: ${BUILD_IMAGE_IMAGE_NAME}:${BUILD_IMAGE_IMAGE_TAG}"
docker build -t "${BUILD_IMAGE_IMAGE_NAME}:${BUILD_IMAGE_IMAGE_TAG}" .
