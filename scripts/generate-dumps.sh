#!/bin/sh

set -eu

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}"

# generate dump within docker container
docker exec testdb pg_dump -h localhost -p 5432 -U dbadmin -d jore4e2e --schema-only -f /tmp/routesdb-dump.sql
docker exec testdb pg_dump -h localhost -p 5432 -U dbadmin -d timetablesdb --schema-only -f /tmp/timetablesdb-dump.sql

# retrieving the dumps from the docker container
docker cp testdb:/tmp/routesdb-dump.sql ../migrations/
docker cp testdb:/tmp/timetablesdb-dump.sql ../migrations/
