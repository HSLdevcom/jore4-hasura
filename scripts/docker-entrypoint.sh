#!/bin/sh

set -eu

REPLACE_PLACEHOLDERS_SCRIPT='/app/scripts/replace-placeholders-in-sql-schema-migrations.sh'

# read secrets into environment variables
. /app/scripts/read-secrets.sh

# Replace the possible placeholders in the SQL schema migrations.
#
# HASURA_GRAPHQL_MIGRATIONS_DIR is defined in the Dockerfile.
"${REPLACE_PLACEHOLDERS_SCRIPT}" "${SECRET_STORE_BASE_PATH}" "${HASURA_GRAPHQL_MIGRATIONS_DIR}"

# psql base command
PSQL_CMD="psql -h ${DB_HOSTNAME} -p 5432 -U ${DB_USERNAME} -d ${DB_NAME}"

# check whether hasura hdb catalog already exists
HDB_CATALOG_EXISTS_QUERY=$(cat << EOF
SELECT EXISTS (
  SELECT FROM pg_tables
  WHERE schemaname = 'hdb_catalog'
    AND tablename  = 'hdb_version'
);
EOF
)
HDB_CATALOG_EXISTS=`PGPASSWORD="${DB_PASSWORD}" ${PSQL_CMD} -t -c "${HDB_CATALOG_EXISTS_QUERY}"`
echo "HDB_CATALOG_EXISTS: $HDB_CATALOG_EXISTS"

# hasura hdb catalog exists -> remove the entries for the repeatable migrations so that they are rerun
if [ $HDB_CATALOG_EXISTS = "t" ]; then

BEFORE_MIGRATE_TIMESTAMP="1000000000000"
AFTER_MIGRATE_TIMESTAMP="2000000000000"

# remove "before migrate" and "after migrate" hook migrations from both network and timetables databases
REMOVE_REPEATABLE_MIGRATIONS_QUERY=$(cat << EOF
update hdb_catalog.hdb_version set cli_state =
  (cli_state
  #- '{migrations,default,$BEFORE_MIGRATE_TIMESTAMP}'
  #- '{migrations,default,$AFTER_MIGRATE_TIMESTAMP}'
  #- '{migrations,timetables,$BEFORE_MIGRATE_TIMESTAMP}'
  #- '{migrations,timetables,$AFTER_MIGRATE_TIMESTAMP}')
EOF
)

PGPASSWORD="${DB_PASSWORD}" ${PSQL_CMD} -c "${REMOVE_REPEATABLE_MIGRATIONS_QUERY}"
fi

# Pass on the execution to Hasura's own docker-entrypoint.sh file to (re)run the migrations
HASURA_GRAPHQL_ADMIN_SECRET="$HASURA_ADMIN_SECRET" \
  HASURA_GRAPHQL_DATABASE_URL="postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOSTNAME}:5432/${DB_NAME}" \
  HASURA_TIMETABLES_DATABASE_URL="postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOSTNAME}:5432/${DB_TIMETABLES_NAME}" \
  exec /bin/docker-entrypoint.sh "$@"
