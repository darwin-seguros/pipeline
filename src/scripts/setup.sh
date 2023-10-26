#!/bin/bash
SETUP_CONFIGURATION_PATH="$(echo "${SETUP_CONFIGURATION_PATH}" | circleci env subst)"
SETUP_JSON_FILE="$(echo "${SETUP_JSON_FILE}" | circleci env subst)"
SETUP_LOOKUP_KEY="$(echo "${SETUP_LOOKUP_KEY}" | circleci env subst)"
SETUP_GIT_BRANCH="$(echo "${SETUP_GIT_BRANCH}" | circleci env subst)"

echo "SETUP_CONFIGURATION_PATH = ${SETUP_CONFIGURATION_PATH}"
echo "SETUP_JSON_FILE = ${SETUP_JSON_FILE}"
echo "SETUP_LOOKUP_KEY = ${SETUP_LOOKUP_KEY}"
echo "SETUP_GIT_BRANCH = ${SETUP_GIT_BRANCH}"

cp "$(jq -r ".${SETUP_LOOKUP_KEY}" "${SETUP_JSON_FILE}")" "${SETUP_CONFIGURATION_PATH}"
cat "${SETUP_JSON_FILE}"

cat "${SETUP_CONFIGURATION_PATH}"

jq "del(.${SETUP_LOOKUP_KEY})" "${SETUP_JSON_FILE}" > params.json
rm "${SETUP_JSON_FILE}"
cp params.json "${SETUP_JSON_FILE}"

BRANCH=$(echo "${SETUP_GIT_BRANCH}" | cut -d"/" -f1)

if [ "${BRANCH}" = "develop" ];
then
      CONTEXT="aws-dev"
      ENVIRONMENT="development"
      DOTENV="dev"
      TAG="current"
fi

if [ "${BRANCH}" = "main" ];
then
      CONTEXT="aws-prod"
      ENVIRONMENT="production"
      DOTENV="prod"
      TAG="stable"
fi

if [ "${BRANCH}" = "release" ] || [ "${BRANCH}" = "staging" ];
then
      CONTEXT="aws-staging"
      ENVIRONMENT="staging"
      DOTENV="staging"
      TAG="latest"
fi

echo "BRANCH = ${BRANCH}"
echo "CONTEXT = ${CONTEXT}"
echo "ENVIRONMENT = ${ENVIRONMENT}"
echo "DOTENV = ${DOTENV}"
echo "TAG = ${TAG}"

# shellcheck disable=SC2005,SC2154
jq --arg a "${ENVIRONMENT}" ".environment = $a" "${SETUP_JSON_FILE}" > "tmp"
mv "tmp" "${SETUP_JSON_FILE}"

# shellcheck disable=SC2005,SC2154
jq --arg a "${CONTEXT}" ".context_name = $a" "${SETUP_JSON_FILE}" > "tmp"
mv "tmp" "${SETUP_JSON_FILE}"

# shellcheck disable=SC2005,SC2154
jq --arg a "${TAG}" ".tag = $a" "${SETUP_JSON_FILE}" > "tmp"
mv "tmp" "${SETUP_JSON_FILE}"

# shellcheck disable=SC2005,SC2154
jq --arg a "${DOTENV}" ".dotenv = $a" "${SETUP_JSON_FILE}" > "tmp"
mv "tmp" "${SETUP_JSON_FILE}"

jq "." "${SETUP_JSON_FILE}"
