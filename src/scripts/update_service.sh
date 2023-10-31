#!/bin/sh
UPDATE_SERVICE_DOTENV="$(echo "${UPDATE_SERVICE_DOTENV}" | circleci env subst)"
UPDATE_SERVICE_ECR_URL="$(echo "${UPDATE_SERVICE_ECR_URL}" | circleci env subst)"
UPDATE_SERVICE_IMAGE_NAME="$(echo "${UPDATE_SERVICE_IMAGE_NAME}" | circleci env subst)"
UPDATE_SERVICE_IMAGE_TAG="$(echo "${UPDATE_SERVICE_IMAGE_TAG}" | circleci env subst)"
UPDATE_SERVICE_TAG="$(echo "${UPDATE_SERVICE_TAG}" | circleci env subst)"

echo "MANIFEST = ${GIT_MANIFEST_SECRET}"

cd ./k8s_helpers || return
npm install fs js-yaml dotenv
cd .. || return
node ./k8s_helpers/create_config_map.js "./.env.${UPDATE_SERVICE_DOTENV}" > configmap.yml

git config --global user.email "devops@darwinseguros.com"
git config --global user.name "DevOps"
git clone "https://${GIT_MANIFEST_SECRET}@dev.azure.com/darwin-seguros/AWS/_git/kubernete-manifest"
echo "Clone k8s manifest repo"

cp -rf configmap.yml "kubernete-manifest/${UPDATE_SERVICE_IMAGE_NAME}/${UPDATE_SERVICE_DOTENV}/configmap.yml"
echo "Update configmap on repository"

sed -i 's/version: .*$/version: '"$(date +%Y%m%d%H%M%S)"'/g' "kubernete-manifest/${UPDATE_SERVICE_IMAGE_NAME}/${UPDATE_SERVICE_DOTENV}/deployment.yml"
echo "Updated deployment on repository"

aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" | docker login --username AWS --password-stdin "${UPDATE_SERVICE_ECR_URL}/${UPDATE_SERVICE_IMAGE_NAME}"
docker pull "${UPDATE_SERVICE_ECR_URL}/${UPDATE_SERVICE_IMAGE_NAME}:${UPDATE_SERVICE_IMAGE_TAG}"
docker tag "${UPDATE_SERVICE_ECR_URL}/${UPDATE_SERVICE_IMAGE_NAME}:${UPDATE_SERVICE_IMAGE_TAG}" "${UPDATE_SERVICE_ECR_URL}/${UPDATE_SERVICE_IMAGE_NAME}:${UPDATE_SERVICE_TAG}"
docker push "${UPDATE_SERVICE_ECR_URL}/${UPDATE_SERVICE_IMAGE_NAME}:${UPDATE_SERVICE_TAG}"

cd kubernete-manifest || return
git pull
git add .
git commit -m "Updating ${UPDATE_SERVICE_IMAGE_NAME}/${UPDATE_SERVICE_DOTENV} configmap by pipeline tag: ${CIRCLE_BUILD_NUM}"
git push
echo "Push changes to k8s manifest repo"
