#!/bin/sh
UPDATE_CLUSTER="$(echo "${UPDATE_CLUSTER}" | circleci env subst)"
UPDATE_SERVICE="$(echo "${UPDATE_SERVICE}" | circleci env subst)"

echo "CLUSTER = ${UPDATE_CLUSTER}"
echo "SERVICE = ${UPDATE_SERVICE}"

aws ecs update-service --region "${AWS_DEFAULT_REGION}" --cluster "${UPDATE_CLUSTER}" --service "${UPDATE_SERVICE}" --force-new-deployment  --no-cli-pager || exit 0
