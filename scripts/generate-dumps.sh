#!/bin/sh

set -eu

# Allow running from any working directory
WD=$(dirname $(realpath "$0"))
TEMP_DIR=$(mktemp -d)

cd "${TEMP_DIR}"

# Generate dump within docker container
docker exec testdb pg_dump -h localhost -p 5432 -U dbadmin -d jore4e2e --schema-only -f /tmp/routesdb-dump.sql
docker exec testdb pg_dump -h localhost -p 5432 -U dbadmin -d timetablesdb --schema-only -f /tmp/timetablesdb-dump.sql

# Retrieve the dumps from the docker container
docker cp testdb:/tmp/routesdb-dump.sql ./routesdb-dump.sql
docker cp testdb:/tmp/timetablesdb-dump.sql ./timetablesdb-dump.sql

# Get the sorting tool
curl -o ./pgdump-sort.py https://raw.githubusercontent.com/tigra564/pgdump-sort/0c05da4d5960c0293a61af4feb167d9ef89d4e70/pgdump-sort
python3 -m venv .
python3 -m pip install docopt

# Sort the dumps
python3 ./pgdump-sort.py ./routesdb-dump.sql ./routesdb-sorted.sql
python3 ./pgdump-sort.py ./timetablesdb-dump.sql ./timetablesdb-sorted.sql

# Move the dumps to the repo dir
cp ./routesdb-sorted.sql "${WD}/../migrations/routesdb-dump.sql"
cp ./timetablesdb-sorted.sql "${WD}/../migrations/timetablesdb-dump.sql"
