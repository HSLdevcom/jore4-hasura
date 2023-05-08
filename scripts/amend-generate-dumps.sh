#!/bin/sh

# Recreates dependencies, generates database dumps and adds them to current commit.
#
# NB: because the dependencies are recreated, the testdb gets erased.
#
# Intended to be used with git rebase, eg:
#   git rebase origin/main --exec=./scripts/amend-generate-dumps.sh
#
# Can also be used outside rebase, in which case the changes get amended to current commit.
#
# Known caveats:
# - Does not detect if migrations ran successfully.
#   This might result in incorrect dumps being created (most SQL shown as removed).
#   Thus the commits should still be manually checked in case there are any clear anomalies.

set -eu

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}"

if ! git diff --quiet; then
  echo "There are uncommitted changes. Please commit or stash them before running the script."
  exit 1
fi

# Generate dumps expects generic image to have been built.
echo "Setting docker target."
./set-docker-target.sh generic

echo "Restarting dependencies to recreate test database."
bash ./stop-dependencies.sh
bash ./start-dependencies.sh --detach

# It is important that DB is all ready and migrations ahve been ran, before we try to generate the dumps.
echo "Waiting for docker images to be ready."
until [ "`docker inspect -f {{.State.Health.Status}} testdb`"=="healthy" ]; do
  sleep 0.1;
done;
until [ "`docker inspect -f {{.State.Health.Status}} hasura`"=="healthy" ]; do
  sleep 0.1;
done;
# Merely being healthy doesn't seem to be enough: running migrations might not have finished.
# TODO: is there a better way?
sleep 5;

echo "Generating dumps."
bash ./generate-dumps.sh
echo "Finished generating dumps."

echo "Stopping dependencies."
bash ./stop-dependencies.sh

echo "Committing modified dump files."
git add ../migrations/routesdb-dump.sql
git add ../migrations/timetablesdb-dump.sql

echo "Restoring default build target."
git checkout -- ../docker/docker-compose.custom.yml

if ! git diff --quiet; then
  echo "Unexpected changes made when generating dumps. Aborting."
  exit 1
fi

echo "Amending current commit."
git commit --amend --no-edit
