#!/usr/bin/env bash

set -euo pipefail

# This script is used to enable repeatable migrations in Hasura. It does the following:
# 1. checks if Hasura migrations have ever been run. If not, there's no need for any tweaks
# 2. finds all the migrations that match the "<timestamp>_R_<migration name>" pattern
# 3. removes these timestamp entries from Hasura's hdb_catalog.hdb_version table
# When hasura is started, it thinks that these migrations have not been run yet so it runs them again
# Note: we require repeatable migrations to be idempotent

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
HDB_CATALOG_EXISTS="$(PGPASSWORD="${DB_PASSWORD}" ${PSQL_CMD} -Atq -c "${HDB_CATALOG_EXISTS_QUERY}")"
echo "HDB_CATALOG_EXISTS: $HDB_CATALOG_EXISTS"

# 1. hdb catalog does not exist (yet), no need to tweak migrations. Exit with success
if [ "$HDB_CATALOG_EXISTS" != "t" ]; then
  echo "hdb_catalog does not exist (yet), no need to tweak migrations"
  exit 0;
fi

# 2. find the repeatable migrations ("timestamp_R_name") in migrations dir
DATABASES=( "default" "timetables" "main" )
for DB in "${DATABASES[@]}"
do
  echo "Looking for repeatable migrations for database: $DB"

  # use regex to find all matching migration names and grep to extract the timestamp part, then put it into an array
  TIMESTAMPS=($(find "${HASURA_GRAPHQL_MIGRATIONS_DIR}" -type d -regex ".*/${DB}/[0-9]*_R_.*" | grep -oE "[0-9]{13}"))

  echo "Found repeatable migrations: ${#TIMESTAMPS[@]}"

  for TIMESTAMP in "${TIMESTAMPS[@]}"
  do

    # Migration folder versions use a fixed width (13 chars). Hasura may store
    # the same version key without leading zeros, so prefer the fixed-width
    # key and otherwise fall back to the normalized key.
    NORMALIZED_TIMESTAMP="$(echo "$TIMESTAMP" | sed -E 's/^0+//')"
    if [ -z "$NORMALIZED_TIMESTAMP" ]; then
      NORMALIZED_TIMESTAMP="0"
    fi

    # build query to remove one repeatable migration key from hdb_catalog.
    # Prefer the original key when present, otherwise remove normalized key.
    REMOVE_REPEATABLE_MIGRATIONS_QUERY="UPDATE hdb_catalog.hdb_version SET cli_state = CASE
        WHEN (cli_state->'migrations'->'$DB' ? '$TIMESTAMP')
          THEN (cli_state #- '{migrations,$DB,$TIMESTAMP}')
        WHEN (cli_state->'migrations'->'$DB' ? '$NORMALIZED_TIMESTAMP')
          THEN (cli_state #- '{migrations,$DB,$NORMALIZED_TIMESTAMP}')
        ELSE cli_state
      END"

    # run query
    PGPASSWORD="${DB_PASSWORD}" ${PSQL_CMD} -c "${REMOVE_REPEATABLE_MIGRATIONS_QUERY}"
  done
done
