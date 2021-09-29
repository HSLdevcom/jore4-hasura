#!/bin/bash

# NB: In some environments (namely in the CI), /dev/urandom might not be available for entropy. Therefore,
# secrets should be generated using another method and passed to this script as environment variables
# (JORE4HASURA_HASURA_ADMIN_SECRET and JORE4HASURA_DB_PASSWORD, see below).

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

generate_password () {
  # SIGPIPE ensues from writing into the pipe after the reading stops so use
  # echo for pipefail.
  echo "$(LC_CTYPE=C </dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
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

HASURA_ADMIN_SECRET="${JORE4HASURA_HASURA_ADMIN_SECRET:-$(generate_password)}"
DB_USERNAME='postgres'
DB_PASSWORD="${JORE4HASURA_DB_PASSWORD:-$(generate_password)}"
DB_HOSTNAME='postgis'
DB_NAME='postgres'
DB_AUTH_USERNAME='jore4auth'
JORE3_IMPORTER_DB_USERNAME='jore3importer'

# Write the secrets for Hasura.
mkdir -p "${SECRETS_DIR}"
echo "${HASURA_ADMIN_SECRET}" > "${SECRETS_DIR}/hasura-admin-secret"
echo "${DB_USERNAME}" > "${SECRETS_DIR}/db-username"
echo "${DB_PASSWORD}" > "${SECRETS_DIR}/db-password"
echo "${DB_HOSTNAME}" > "${SECRETS_DIR}/db-hostname"
echo "${DB_NAME}" > "${SECRETS_DIR}/db-name"
echo "${DB_AUTH_USERNAME}" > "${SECRETS_DIR}/db-auth-username"
echo "${JORE3_IMPORTER_DB_USERNAME}" > "${SECRETS_DIR}/db-jore3importer-username"

# Write the secrets in the .env file.
: > "${ENV_PATH}"
echo "POSTGRES_USER=${DB_USERNAME}" >> "${ENV_PATH}"
echo "POSTGRES_PASSWORD=${DB_PASSWORD}" >> "${ENV_PATH}"
echo "HASURA_GRAPHQL_ADMIN_SECRET=${HASURA_ADMIN_SECRET}" >> "${ENV_PATH}"
