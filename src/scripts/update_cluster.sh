#!/bin/sh

UPDATE_CLUSTER="$(echo "${UPDATE_CLUSTER}" | circleci env subst)"
UPDATE_SERVICE="$(echo "${UPDATE_SERVICE}" | circleci env subst)"

echo "CLUSTER = ${UPDATE_CLUSTER}"
echo "SERVICE = ${UPDATE_SERVICE}"

CLUSTER_NAME=$(aws ecs list-clusters | jq -r '.clusterArns[] | split("/") | .[1]')

UPDATE_SERVICE_FIRST_WORD=$(echo "$UPDATE_SERVICE" | cut -d '-' -f1)

SERVICES=$(aws ecs list-services --region "${AWS_DEFAULT_REGION}" --cluster "${CLUSTER_NAME}" --output json | jq -r '.serviceArns[] | split("/") | .[-1] | select(startswith("'"$UPDATE_SERVICE_FIRST_WORD"'"))')

for SERVICE in $SERVICES; do
    echo "Atualizando o serviço ${SERVICE}..."
    aws ecs update-service --region "${AWS_DEFAULT_REGION}" --cluster "${CLUSTER_NAME}" --service "${SERVICE}" --force-new-deployment --no-cli-pager || echo "Falha ao atualizar o serviço ${SERVICE}"
done
