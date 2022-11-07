#!/bin/bash

set -eu

# read secrets into environment variables
. /scripts/read-secrets.sh

DB_USERNAME=dbadmin
DB_PASSWORD=adminpassword

# build the list of migration locations that should be executed
build_locations() {
  database_name="$1"

  # generic migration location is added by default
  LOCATIONS="filesystem:$MIGRATIONS_DIR/$database_name/generic"

  # add hsl migration location if enabled
  if [ "$INCLUDE_HSL_MIGRATIONS" == "true" ]; then
    LOCATIONS="$LOCATIONS,filesystem:$MIGRATIONS_DIR/$database_name/hsl"
  fi

  # add hsl migration location if enabled
  if [ "$INCLUDE_SEED_DATA_MIGRATIONS" == "true" ]; then
    LOCATIONS="$LOCATIONS,filesystem:$MIGRATIONS_DIR/$database_name/seed-data"
  fi

  echo "$LOCATIONS"
}

echo "running migrations for networkdb"
FLYWAY_URL="jdbc:postgresql://${DB_HOSTNAME}:5432/${DB_NAME}" \
  FLYWAY_USER="${DB_USERNAME}" \
  FLYWAY_PASSWORD="${DB_PASSWORD}" \
  FLYWAY_LOCATIONS=$(build_locations networkdb) \
  flyway migrate

# FLYWAY_URL="jdbc:postgresql://${DB_HOSTNAME}:5432/${DB_NAME}" \
#   FLYWAY_USER="${DB_USERNAME}" \
#   FLYWAY_PASSWORD="${DB_PASSWORD}" \
#   FLYWAY_LOCATIONS=$(build_locations networkdb) \
#   flyway undo

# echo "running migrations for timetablesdb"
# FLYWAY_URL="jdbc:postgresql://${DB_HOSTNAME}:5432/${DB_TIMETABLES_NAME}" \
#   FLYWAY_USER="${DB_USERNAME}" \
#   FLYWAY_PASSWORD="${DB_PASSWORD}" \
#   FLYWAY_LOCATIONS=$(build_locations timetablesdb) \
#   flyway info
