#!/usr/bin/env bash

set -e

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}/.."

scripts/development.sh remove
