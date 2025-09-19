#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

function create_dev_env
{
  local python=python$(grep 'FROM python:' Dockerfile | head -n 1 | sed -E 's/.*python:([0-9]+.[0-9]+).*/\1/')
  ${python} -m venv venv

  venv/bin/pip install -r requirements/dev.txt
}

function update_deps
{
  venv/bin/pip-compile --strip-extras --upgrade --output-file=requirements/runtime.txt requirements/runtime.in
  venv/bin/pip-compile --strip-extras --upgrade --output-file=requirements/qa.txt requirements/runtime.txt requirements/qa.in
  venv/bin/pip-compile --strip-extras --upgrade --output-file=requirements/dev.txt requirements/qa.txt requirements/dev.in

  venv/bin/pip install -r requirements/dev.txt
}

function test
{
  venv/bin/coverage run -m pytest -v test_reload_schema.py

  venv/bin/coverage report -m

  venv/bin/coverage html
}

function run_linters
{
  venv/bin/ruff check *.py
}

print_usage() {
  echo "
  Usage: $(basename "$0") <command>

  create-dev-env
    Create Python virtual environment for development and install required Python packages

  test
    Run tests and generate coverage report

  lint
    Run linters
  "
}

case "$1" in
  create-dev-env)
    create_dev_env
    ;;


  update-deps)
    update_deps
    ;;

  test)
    test
    ;;

  lint)
    run_linters
    ;;

  *)
    echo ""
    echo "Unknown command: '${1}'"
    print_usage
    exit 1
    ;;
esac
