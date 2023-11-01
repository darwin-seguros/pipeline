#!/bin/bash
SONAR_TOKEN="$(echo "${SONAR_TOKEN}" | circleci env subst)"
SONAR_PROJECT_KEY="$(echo "${SONAR_PROJECT_KEY}" | circleci env subst)"
SONAR_URL="$(echo "${SONAR_URL}" | circleci env subst)"

export SONAR_SCANNER_VERSION=4.7.0.2747
export SONAR_SCANNER_HOME="${HOME}/.sonar/sonar-scanner-${SONAR_SCANNER_VERSION}-linux"
curl --create-dirs -sSLo "${HOME}/.sonar/sonar-scanner.zip" "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip"
unzip -o "${HOME}/.sonar/sonar-scanner.zip" -d "${HOME}/.sonar/"
export PATH="${SONAR_SCANNER_HOME}/bin:${PATH}"
export SONAR_SCANNER_OPTS="-server"


sonar-scanner -Dsonar.projectKey="${SONAR_PROJECT_KEY}" -Dsonar.sources=. -Dsonar.host.url="${SONAR_URL}"