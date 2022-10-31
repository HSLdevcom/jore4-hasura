#!/bin/sh

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}"

set -eu

DOCKER_CMD="docker run -it --rm -v ${PWD}/../migrations:/sql sqlfluff/sqlfluff:1.3.2"
COMMON_PARAMS="--dialect postgres generic/default/1664191395447_validity_time_as_date/up.sql"

if [[ "${1:-x}" == "fix" ]]
then
  echo "fixing linter errors..."
  $DOCKER_CMD fix --show-lint-violations --force $COMMON_PARAMS
else
  echo "displaying linter errors..."
  $DOCKER_CMD lint $COMMON_PARAMS
fi
