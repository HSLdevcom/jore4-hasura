#!/bin/sh

set -eu

cat /tmp/afterMigrate/* > /flyway/sql/afterMigrate.sql
cat /tmp/beforeMigrate/* > /flyway/sql/beforeMigrate.sql
