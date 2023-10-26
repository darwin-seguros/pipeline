#!/bin/sh
SETUP_CONFIGURATION_PATH="$(echo "${SETUP_CONFIGURATION_PATH}" | circleci env subst)"
SETUP_JSON_FILE="$(echo "${SETUP_JSON_FILE}" | circleci env subst)"
SETUP_LOOKUP_KEY="$(echo "${SETUP_LOOKUP_KEY}" | circleci env subst)"
SETUP_GIT_BRANCH="$(echo "${SETUP_GIT_BRANCH}" | circleci env subst)"

cp $(jq -r ".${SETUP_LOOKUP_KEY}" "${SETUP_JSON_FILE}") "${SETUP_CONFIGURATION_PATH}"
cat "${SETUP_JSON_FILE}"

cat "${SETUP_CONFIGURATION_PATH}"

jq "del(.${SETUP_LOOKUP_KEY})" "${SETUP_JSON_FILE}" > params.json
rm "${SETUP_JSON_FILE}"
cp params.json "${SETUP_JSON_FILE}"

contexts_develop="aws-dev"
contexts_main="aws-prod"
contexts_release="aws-staging"
contexts_staging="aws-staging"

environments_develop="development"
environments_main="production"
environments_release="staging"
environments_staging="staging"

dotenv_develop="dev"
dotenv_main="prod"
dotenv_release="staging"
dotenv_staging="staging"

tag_develop="current"
tag_main="stable"
tag_release="latest"
tag_staging="latest"

branch="$(echo ${SETUP_GIT_BRANCH} | cut -d'/' -f1)"
echo "BRANCH = "$branch""

context="contexts_$branch"
echo "CONTEXT = ${!context}"

environment="environments_$branch"
echo "ENVIRONMENT = ${!environment}"

dotenv="dotenv_$branch"
echo "DOTENV = ${!dotenv}"

tag="tag_$branch"
echo "TAG = ${!tag}"

jq --arg a "${!environment}" ".environment = $a" "${SETUP_JSON_FILE}" > "tmp"
mv "tmp" "${SETUP_JSON_FILE}"

jq --arg a "${!context}" ".context_name = $a" "${SETUP_JSON_FILE}" > "tmp"
mv "tmp" "${SETUP_JSON_FILE}"

jq --arg a "${!tag}" ".tag = $a" "${SETUP_JSON_FILE}" > "tmp"
mv "tmp" "${SETUP_JSON_FILE}"

jq --arg a "${!dotenv}" ".dotenv = $a" "${SETUP_JSON_FILE}" > "tmp"
mv "tmp" "${SETUP_JSON_FILE}"

jq "." "${SETUP_JSON_FILE}"
