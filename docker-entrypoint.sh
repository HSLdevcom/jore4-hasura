#!/bin/sh
HASURA_GRAPHQL_DATABASE_URL="$(cat /secrets/HASURA_GRAPHQL_DATABASE_URL)" \
  HASURA_GRAPHQL_ADMIN_SECRET="$(cat /secrets/HASURA_GRAPHQL_ADMIN_SECRET)" \
  exec /bin/docker-entrypoint.sh

