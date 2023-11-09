#!/bin/sh
UPDATE_APIGW_IMAGE_NAME="$(echo "${UPDATE_APIGW_IMAGE_NAME}" | circleci env subst)"

echo "Running update api gateway"
API_ID=$(aws apigateway get-rest-apis --query "items[?name=='${UPDATE_APIGW_IMAGE_NAME}'].id")
if test -z "$API_ID" 
then
      echo "API Gateway not exists"
else
      aws apigateway put-rest-api --rest-api-id "${API_ID}" --mode merge --body 'fileb://infra/terraform/swagger-spec.json'
fi
