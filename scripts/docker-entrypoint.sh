#!/bin/sh

set -eu

REPLACE_PLACEHOLDERS_SCRIPT='/app/scripts/replace-placeholders-in-sql-schema-migrations.sh'

# read secrets into environment variables
. /app/scripts/read-secrets.sh

# Replace the possible placeholders in the SQL schema migrations.
#
# HASURA_GRAPHQL_MIGRATIONS_DIR is defined in the Dockerfile.
"${REPLACE_PLACEHOLDERS_SCRIPT}" "${SECRET_STORE_BASE_PATH}" "${HASURA_GRAPHQL_MIGRATIONS_DIR}"

# Tweak Hasura internal database to enable repeatable migrations
/app/scripts/repeatable-migrations.sh

# Pass on the execution to Hasura's own docker-entrypoint.sh file to (re)run the migrations
HASURA_GRAPHQL_ADMIN_SECRET="$HASURA_ADMIN_SECRET" \
  HASURA_GRAPHQL_DATABASE_URL="postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOSTNAME}:5432/${DB_NAME}" \
  HASURA_TIMETABLES_DATABASE_URL="postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOSTNAME}:5432/${DB_TIMETABLES_NAME}" \
  HASURA_TIAMAT_SCHEMA_URL="http://${TIAMAT_HOSTNAME:-jore4-tiamat}:${TIAMAT_PORT:-1888}/services/stop_places/graphql" \
  exec /bin/docker-entrypoint.sh "$@"
