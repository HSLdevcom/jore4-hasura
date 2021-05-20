#!/bin/bash

set -Eeuo pipefail

SECRETS_DIR='./secrets'
ENV_PATH='./.env'

prompt () {
  while true; do
    read -r -p "Do you wish to overwrite your secrets in ${SECRETS_DIR} and ${ENV_PATH}? [y/n] " answer
    case "${answer}" in
      [Yy]* ) echo 'Creating secrets' && return 0;;
      [Nn]* ) echo 'Doing nothing and exiting' && exit 0;;
      * ) echo "Please answer with Y or y for yes or N or n for no.";;
    esac
  done
}

generate_password () {
  # SIGPIPE ensues from writing into the pipe after the reading stops so use
  # echo for exit status.
  echo "$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
}

prompt

HASURA_GRAPHQL_ADMIN_SECRET="$(generate_password)"
DB_USERNAME='postgres'
DB_PASSWORD="$(generate_password)"
DB_HOSTNAME='postgis'
DB_NAME='postgres'

# Write the secrets for Hasura.
mkdir -p "${SECRETS_DIR}"
echo "${HASURA_GRAPHQL_ADMIN_SECRET}" > "${SECRETS_DIR}/hasura-admin-secret"
echo "${DB_USERNAME}" > "${SECRETS_DIR}/db-username"
echo "${DB_PASSWORD}" > "${SECRETS_DIR}/db-password"
echo "${DB_HOSTNAME}" > "${SECRETS_DIR}/db-hostname"
echo "${DB_NAME}" > "${SECRETS_DIR}/db-name"

# Write the secrets for PostGIS.
: > "${ENV_PATH}"
echo "POSTGRES_USER=${DB_USERNAME}" >> "${ENV_PATH}"
echo "POSTGRES_PASSWORD=${DB_PASSWORD}" >> "${ENV_PATH}"
