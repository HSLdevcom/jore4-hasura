#!/bin/sh

set -eu

REPLACE_PLACEHOLDERS_SCRIPT='/app/scripts/replace-placeholders-in-sql-schema-migrations.sh'

# read secrets into environment variables
. /app/scripts/read-secrets.sh

# Replace the possible placeholders in the SQL schema migrations.
#
# HASURA_GRAPHQL_MIGRATIONS_DIR is defined in the Dockerfile.
"${REPLACE_PLACEHOLDERS_SCRIPT}" "${SECRET_STORE_BASE_PATH}" "${HASURA_GRAPHQL_MIGRATIONS_DIR}"

# This script extends the functionality of the original Hasura docker image’s /bin/docker-entrypoint.sh script
# HASURA_GRAPHQL_DATABASE_URL format: postgres://<user>:<password>@<host>:<port>/<db-name>
HASURA_GRAPHQL_ADMIN_SECRET="$HASURA_ADMIN_SECRET" \
  HASURA_GRAPHQL_DATABASE_URL="postgres://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOSTNAME}:5432/${DB_NAME}" \
  HASURA_TIMETABLES_DATABASE_URL="postgres://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOSTNAME}:5432/${DB_TIMETABLES_NAME}" \
  exec /bin/docker-entrypoint.sh "$@"
