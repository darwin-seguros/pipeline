#!/bin/bash
SETUP_DEFAULT_BRANCHS_OIDC_TOKEN="$(echo "${SETUP_DEFAULT_BRANCHS_OIDC_TOKEN}" | circleci env subst)"
SETUP_PROJECT="$(echo "${SETUP_PROJECT}" | circleci env subst)"

curl --location --request PUT "https://circleci.com/api/v1.1/project/github/darwin-seguros/${SETUP_PROJECT}/settings" \
     --header "Circle-Token: ${SETUP_DEFAULT_BRANCHS_OIDC_TOKEN}" \
     --header "Accept: application/json" \
     --header "Content-Type: application/json" \
     --data '{"feature_flags":{"pr-only-branch-overrides":".*"}}'