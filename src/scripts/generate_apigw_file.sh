#!/bin/sh
GENERATE_APIGW_FILE_DOTENV="$(echo "${GENERATE_APIGW_FILE_DOTENV}" | circleci env subst)"
GENERATE_APIGW_FILE_IMAGE_NAME="$(echo "${GENERATE_APIGW_FILE_IMAGE_NAME}" | circleci env subst)"

echo "Running generate swagger file"
VPC_LINK_ID=$(aws apigateway get-vpc-links | jq -r '.items[0].id') \
BASE_URI="https://${GENERATE_APIGW_FILE_IMAGE_NAME}.${GENERATE_APIGW_FILE_DOTENV}.cloud.darwinseguros.com" npm run generate:swagger
