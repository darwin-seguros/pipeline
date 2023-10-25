#!/bin/sh
DEPLOY_LAMBDA_PATH="$(echo "${DEPLOY_LAMBDA_PATH}" | circleci env subst)"
DEPLOY_LAMBDA_DOTENV="$(echo "${DEPLOY_LAMBDA_DOTENV}" | circleci env subst)"

echo "Installing chalice"
cd ${DEPLOY_LAMBDA_PATH}
python3 --version
sudo apt-get update
sudo apt-get install python3-virtualenv
sudo apt-get install python3-venv
python3 -m venv venv37
python3 -m pip install chalice
pip install -r requirements.txt
chalice deploy --stage ${DEPLOY_LAMBDA_DOTENV}
