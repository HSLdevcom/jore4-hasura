#!/bin/bash

set -Eeuo pipefail

SECRETS_DIR='./secrets'
ENV_PATH='./.env'

prompt () {
  while true; do
    echo "Going to overwrite secrets in:"
    echo "- ${SECRETS_DIR}"
    echo "- ${ENV_PATH}"
    read -r -p "Do you wish to proceed? [y/n] " answer
    case "${answer}" in
      [Yy]* ) echo 'Creating secrets' && return 0;;
      [Nn]* ) echo 'Doing nothing and exiting' && exit 0;;
      * ) echo "Please answer with Y or y for yes or N or n for no.";;
    esac
  done
}

FORCE=

while [[ $# -gt 0 ]]; do
  case "$1" in
    "--force"|"-f" )
      FORCE=true
      shift
      ;;
    * )
      echo "usage: $0 [--force|-f]"
      exit 1
      ;;
  esac
done

[ -z "$FORCE" ] && prompt

HASURA_ADMIN_SECRET='hasuraadminsecret'
DB_HOSTNAME='postgis'
DB_NAME='postgres'
DB_ADMIN_USERNAME='postgres'
DB_ADMIN_PASSWORD='postgrespassword'
DB_HASURA_USERNAME='jore4hasura'
DB_HASURA_PASSWORD='jore4hasurapassword'
DB_AUTH_USERNAME='jore4auth'
JORE3_IMPORTER_DB_USERNAME='jore3importer'

# Write the secrets for Hasura.
mkdir -p "${SECRETS_DIR}"
echo "${HASURA_ADMIN_SECRET}" > "${SECRETS_DIR}/hasura-admin-secret"
echo "${DB_HOSTNAME}" > "${SECRETS_DIR}/db-hostname"
echo "${DB_NAME}" > "${SECRETS_DIR}/db-name"
echo "${DB_HASURA_USERNAME}" > "${SECRETS_DIR}/db-username"
echo "${DB_HASURA_PASSWORD}" > "${SECRETS_DIR}/db-password"
echo "${DB_AUTH_USERNAME}" > "${SECRETS_DIR}/db-auth-username"
echo "${JORE3_IMPORTER_DB_USERNAME}" > "${SECRETS_DIR}/db-jore3importer-username"

# Write the secrets in the .env file.
: > "${ENV_PATH}"
echo "POSTGRES_USER=${DB_ADMIN_USERNAME}" >> "${ENV_PATH}"
echo "POSTGRES_PASSWORD=${DB_ADMIN_PASSWORD}" >> "${ENV_PATH}"
echo "HASURA_GRAPHQL_ADMIN_SECRET=${HASURA_ADMIN_SECRET}" >> "${ENV_PATH}"
