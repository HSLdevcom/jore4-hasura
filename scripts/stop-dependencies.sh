#!/usr/bin/env bash

set -euo pipefail

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}/.."

# stop the dependencies
docker compose -f ./docker/docker-compose.yml -f ./docker/docker-compose.custom.yml down
