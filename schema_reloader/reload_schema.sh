#! /usr/bin/env bash

set -euo pipefail


function hasura_metadata_call {
  curl \
    --silent \
    --show-error \
    --header "Content-Type: application/json" \
    --header "x-hasura-admin-secret: $(cat /mnt/secrets-store/hasura-password)" \
    --request POST \
    --data "${1}" \
    --silent \
    ${HASURA_BASE_URL}/v1/metadata
}


response=$(hasura_metadata_call '{"type":"get_inconsistent_metadata","args":{}}')

is_consistent=$(echo "${response}" | jq .is_consistent)

if [[ ${is_consistent} == "null" ]]
then
  echo "Failed to read metadata status: ${response}"
  exit 1
fi

if [[ ${is_consistent} == "true" ]]
then
  echo 'Remote schemas are up-to-date'
  exit 0
fi

echo 'Reloading remote schemas'

hasura_metadata_call '{"type":"reload_metadata","args":{"reload_remote_schemas":true,"reload_sources":true}}'
