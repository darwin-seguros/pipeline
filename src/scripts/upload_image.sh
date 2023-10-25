#!/bin/sh
BUILD_IMAGE_ECR_URL="$(echo "${BUILD_IMAGE_ECR_URL}" | circleci env subst)"
BUILD_IMAGE_IMAGE_NAME="$(echo "${BUILD_IMAGE_IMAGE_NAME}" | circleci env subst)"
BUILD_IMAGE_IMAGE_TAG="$(echo "${BUILD_IMAGE_IMAGE_TAG}" | circleci env subst)"

aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" docker login --username AWS --password-stdin "${BUILD_IMAGE_ECR_URL}/${BUILD_IMAGE_IMAGE_NAME}"
docker tag "${BUILD_IMAGE_IMAGE_NAME}:${BUILD_IMAGE_IMAGE_TAG}" "${BUILD_IMAGE_ECR_URL}/${BUILD_IMAGE_IMAGE_NAME}:${BUILD_IMAGE_IMAGE_TAG}"
docker push "${BUILD_IMAGE_ECR_URL}/${BUILD_IMAGE_IMAGE_NAME}:${BUILD_IMAGE_IMAGE_TAG}"
