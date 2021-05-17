#!/bin/sh

set -euo pipefail

WD=$(dirname "$0")
cd "${WD}"

SECRETS_DIRECTORY="./secrets"
HASURA_ADMIN_SECRET="$SECRETS_DIRECTORY"/"hsl-jore4-hasura-graphql-admin-secret"
DB_USERNAME="$SECRETS_DIRECTORY"/"db-username"
DB_PASSWORD="$SECRETS_DIRECTORY"/"db-password"
DB_HOSTNAME="$SECRETS_DIRECTORY"/"db-hostname"
DB_NAME="$SECRETS_DIRECTORY"/"db-name"

mkdir -p "$SECRETS_DIRECTORY"

if [ ! -f "$DB_USERNAME" ]; then
  echo "postgres" > "$DB_USERNAME"
fi
if [ ! -f "$DB_PASSWORD" ]; then
  echo "postgres" > "$DB_PASSWORD"
fi
if [ ! -f "$DB_HOSTNAME" ]; then
  echo "postgis" > "$DB_HOSTNAME"
fi
if [ ! -f "$DB_NAME" ]; then
  echo "postgres" > "$DB_NAME"
fi
