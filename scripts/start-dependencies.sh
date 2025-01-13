#!/usr/bin/env bash

# based on https://github.com/HSLdevcom/jore4-tools#download-docker-bundlesh

set -euo pipefail

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}/.."

echo "Downloading latest version of E2E docker-compose package..."
curl https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/download-docker-bundle.sh | bash

# start up test database and hasura for migrations
docker compose -f ./docker/docker-compose.yml -f ./docker/docker-compose.custom.yml up --build "$@" jore4-testdb jore4-hasura jore4-auth jore4-tiamat
