#!/usr/bin/env bash

if [[ "$PWD" != *scripts ]]; then
  cd "$(dirname "$0")"
fi

if [[ -z ${1} ]]; then
  echo "Usage: specific-schema.sh environment"
  echo "Possible environment values are currently:"
  ls -1 -d ../migrations/*/ | cut -f3 -d'/'
  exit 1
fi

set -euo pipefail

sed -i "s/metadata_directory:.*/metadata_directory: metadata\/${1}/i" ../config.yaml
sed -i "s/migrations_directory:.*/migrations_directory: migrations\/${1}/i" ../config.yaml