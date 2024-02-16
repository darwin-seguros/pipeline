#!/bin/sh

UPDATE_CLUSTER="$(echo "${UPDATE_CLUSTER}" | circleci env subst)"
UPDATE_SERVICE="$(echo "${UPDATE_SERVICE}" | circleci env subst)"

echo "CLUSTER = ${UPDATE_CLUSTER}"
echo "SERVICE = ${UPDATE_SERVICE}"

SERVICES=$(aws ecs list-services --region "${AWS_DEFAULT_REGION}" --cluster "${UPDATE_CLUSTER}" --query "serviceArns[?starts_with(@, '${UPDATE_SERVICE}')].split('/').[-1]" --output text)

for SERVICE in $SERVICES; do
    echo "Atualizando o serviço ${SERVICE}..."
    aws ecs update-service --region "${AWS_DEFAULT_REGION}" --cluster "${UPDATE_CLUSTER}" --service "${SERVICE}" --force-new-deployment --no-cli-pager || echo "Falha ao atualizar o serviço ${SERVICE}"
done
