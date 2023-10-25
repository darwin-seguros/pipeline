#!/bin/sh
GENERATE_APIGW_FILE_IMAGE_NAME="$(echo "${GENERATE_APIGW_FILE_IMAGE_NAME}" | circleci env subst)"

echo "Running update api gateway"
API_ID=$(aws apigateway get-rest-apis --query "items[?name=='${GENERATE_APIGW_FILE_IMAGE_NAME}'].id")
if test -z "$API_ID" 
then
      echo "API Gateway not exists"
else
      aws apigateway put-rest-api --rest-api-id h5jamk8fw6 --mode merge --body 'fileb://swagger-spec.json'
fi
