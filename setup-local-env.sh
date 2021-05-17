#!/bin/sh

set -euo pipefail

WD=$(dirname "$0")
cd "${WD}"

SECRETS_DIRECTORY="./secrets"
HASURA_ADMIN_SECRET="$SECRETS_DIRECTORY"/"hsl-jore4-hasura-graphql-admin-secret"
HASURA_USERNAME="$SECRETS_DIRECTORY"/"hsl-jore4-hasura-username"
HASURA_PASSWORD="$SECRETS_DIRECTORY"/"hsl-jore4-hasura-password"
DB_HOSTNAME="$SECRETS_DIRECTORY"/"hsl-jore4-public-db-hostname"
DB_DATABASE="$SECRETS_DIRECTORY"/"hsl-jore4-public-db-database"

[ -d "$SECRETS_DIRECTORY" ] || mkdir "$SECRETS_DIRECTORY"

if [ ! -f "$HASURA_ADMIN_SECRET" ]; then
    export LC_CTYPE=C
    random_filename=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1);
    echo ${random_filename} > ./secrets/hsl-jore4-hasura-graphql-admin-secret
fi
if [ ! -f "$HASURA_USERNAME" ]; then
  echo "postgres" > "$HASURA_USERNAME"
fi
if [ ! -f "$HASURA_PASSWORD" ]; then
  echo "postgres" > "$HASURA_PASSWORD"
fi
if [ ! -f "$DB_HOSTNAME" ]; then
  echo "postgis" > "$DB_HOSTNAME"
fi
if [ ! -f "$DB_DATABASE" ]; then
  echo "postgres" > "$DB_DATABASE"
fi
