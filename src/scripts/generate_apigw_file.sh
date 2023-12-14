#!/bin/sh
GENERATE_APIGW_FILE_DOTENV="$(echo "${GENERATE_APIGW_FILE_DOTENV}" | circleci env subst)"
GENERATE_APIGW_FILE_IMAGE_NAME="$(echo "${GENERATE_APIGW_FILE_IMAGE_NAME}" | circleci env subst)"

echo "Running generate swagger file"
VPC_LINK_ID=$(aws apigateway get-vpc-links | jq -r '.items[0].id') \
SWAGGER_VERSION="${CIRCLE_BUILD_NUM}" \
BASE_URI="https://${GENERATE_APIGW_FILE_IMAGE_NAME}.${GENERATE_APIGW_FILE_DOTENV}.cloud.darwinseguros.com" npm run generate:swagger

API_NAME=$(< swagger-spec-result.json jq -r '.info.title')

API_ID=$(aws apigateway --region "${AWS_DEFAULT_REGION}" get-rest-apis --query "items[?name=='${API_NAME}'].id" | jq -r '.[0]')

API_DEPLOYMENT=$(aws apigateway --region "${AWS_DEFAULT_REGION}" get-deployments --rest-api-id "${API_ID}" | jq -r '.items[0].id')

aws apigateway --region "${AWS_DEFAULT_REGION}" update-deployment --rest-api-id "${API_ID}" --deployment-id "${API_DEPLOYMENT}" --patch-operations op='replace',path='/description',value="${CIRCLE_BUILD_NUM}"
