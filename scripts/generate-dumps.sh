#!/bin/sh

set -eu

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}"

# generate dump within docker container
docker exec testdb pg_dump -h localhost -p 5432 -U dbadmin -d jore4e2e --schema-only -f /tmp/routesdb-dump.sql
docker exec testdb pg_dump -h localhost -p 5432 -U dbadmin -d timetablesdb --schema-only -f /tmp/timetablesdb-dump.sql

# add sorting tool to the container
docker exec testdb apt-get update
docker exec testdb apt-get install python3-minimal python3-docopt curl -y
docker exec testdb curl -o /tmp/pgdump-sort.py https://raw.githubusercontent.com/tigra564/pgdump-sort/master/pgdump-sort

# sort the dumps
docker exec testdb python3 /tmp/pgdump-sort.py /tmp/routesdb-dump.sql /tmp/routesdb-sorted.sql
docker exec testdb python3 /tmp/pgdump-sort.py /tmp/timetablesdb-dump.sql /tmp/timetablesdb-sorted.sql

# retrieving the dumps from the docker container
docker cp testdb:/tmp/routesdb-sorted.sql ../migrations/routesdb-dump.sql
docker cp testdb:/tmp/timetablesdb-sorted.sql ../migrations/timetablesdb-dump.sql
