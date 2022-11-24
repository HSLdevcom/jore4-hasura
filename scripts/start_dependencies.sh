#!/bin/bash

# based on https://github.com/HSLdevcom/jore4-flux#docker-compose

set -euo pipefail

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}"

if ! command -v gh; then
  echo "Please install the github gh tool on your machine."
  exit 1
fi

# initialize package folder
mkdir -p ./docker/update

echo "Downloading latest version of E2E docker-compose package..."
gh auth status || gh auth login

# gh cannot overwrite existing files, therefore first download into separate dir. This way we still have the old copy
# in case the download fails
rm -rf ./docker/update/*
gh release download e2e-docker-compose --repo HSLdevcom/jore4-flux --dir ./docker/update
cp -R ./docker/update/* ./docker

# start up test database and hasura for migrations
docker-compose -f ../docker/docker-compose.yml -f ../docker/docker-compose.custom.yml up --build "$@" jore4-testdb jore4-hasura jore4-auth
