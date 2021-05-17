#!/bin/sh

set -euo pipefail

SECRET_STORE_BASE_PATH="${SECRET_STORE_BASE_PATH:-/run/secrets}"
DB_USERNAME="$(cat ${SECRET_STORE_BASE_PATH}/db-username)"
DB_PASSWORD="$(cat ${SECRET_STORE_BASE_PATH}/db-password)"
DB_HOSTNAME="$(cat ${SECRET_STORE_BASE_PATH}/db-hostname)"
DB_NAME="$(cat ${SECRET_STORE_BASE_PATH}/db-name)"

# HASURA_GRAPHQL_DATABASE_URL format: postgres://<user>:<password>@<host>:<port>/<db-name>
HASURA_GRAPHQL_ADMIN_SECRET="$DB_PASSWORD" \
  HASURA_GRAPHQL_DATABASE_URL="postgres://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOSTNAME}:5432/${DB_NAME}" \
  exec /bin/docker-entrypoint.sh "$@"
