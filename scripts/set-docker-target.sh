#!/usr/bin/env bash

if [[ "$PWD" != *scripts ]]; then
  cd "$(dirname "$0")"
fi

if [[ -z ${1} ]]; then
  echo "Usage: $(basename $0) environment"
  echo "Possible environment values are currently:"
  ls -1 -d ../migrations/*/ | cut -f3 -d'/'
  exit 1
fi

set -euo pipefail

sed -i "s/target: hasura-.*/target: hasura-${1}/i" ../docker/docker-compose.custom.yml
