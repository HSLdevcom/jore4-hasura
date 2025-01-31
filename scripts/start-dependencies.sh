#!/usr/bin/env bash

set -euo pipefail

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}/.."

# Additional Docker Compose services can be passed as argument.
scripts/development.sh start "$@"
