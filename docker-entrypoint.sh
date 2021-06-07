#!/bin/sh

set -eu

SECRET_STORE_BASE_PATH="${SECRET_STORE_BASE_PATH:-/run/secrets}"
HASURA_ADMIN_SECRET="$(cat "${SECRET_STORE_BASE_PATH}/hasura-admin-secret")"
DB_USERNAME="$(cat "${SECRET_STORE_BASE_PATH}/db-username")"
DB_PASSWORD="$(cat "${SECRET_STORE_BASE_PATH}/db-password")"
DB_HOSTNAME="$(cat "${SECRET_STORE_BASE_PATH}/db-hostname")"
DB_NAME="$(cat "${SECRET_STORE_BASE_PATH}/db-name")"
REPLACE_PLACEHOLDERS_SCRIPT='/app/replace-placeholders-in-sql-schema-migrations.sh'

# Replace the possible placeholders in the SQL schema migrations.
#
# HASURA_GRAPHQL_MIGRATIONS_DIR is defined in the Dockerfile.
"${REPLACE_PLACEHOLDERS_SCRIPT}" "${SECRET_STORE_BASE_PATH}" "${HASURA_GRAPHQL_MIGRATIONS_DIR}"

# This script extends the functionality of the original Hasura docker image’s /bin/docker-entrypoint.sh script
# HASURA_GRAPHQL_DATABASE_URL format: postgres://<user>:<password>@<host>:<port>/<db-name>
HASURA_GRAPHQL_ADMIN_SECRET="$HASURA_ADMIN_SECRET" \
  HASURA_GRAPHQL_DATABASE_URL="postgres://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOSTNAME}:5432/${DB_NAME}" \
  exec /bin/docker-entrypoint.sh "$@"
