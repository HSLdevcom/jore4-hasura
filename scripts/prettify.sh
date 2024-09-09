#!/bin/sh

set -eu

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}/../test/hasura"

yarn prettier
