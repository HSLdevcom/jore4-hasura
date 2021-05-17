#!/bin/sh

HASURA_GRAPHQL_ADMIN_SECRET="$(cat /secrets/hsl-jore4-hasura-password)" \
# format: postgres://<user>:<password>@<host>:<port>/<db-name>
  HASURA_GRAPHQL_DATABASE_URL="postgres://$(cat /secrets/hsl-jore4-hasura-username):$(cat /secrets/hsl-jore4-hasura-password)@$(cat /secrets/hsl-jore4-public-db-hostname):5432/$(cat /secrets/hsl-jore4-public-db-database)" \
  exec /bin/docker-entrypoint.sh
