#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

create_dev_env() {
  local python=python$(grep 'FROM python:' Dockerfile | head -n 1 | sed -E 's/.*python:([0-9]+.[0-9]+).*/\1/')
  ${python} -m venv venv

  venv/bin/pip install -r requirements/dev/requirements.txt
}

update_deps() {
  venv/bin/pip-compile --strip-extras --upgrade --output-file=requirements/runtime/requirements.txt requirements/runtime/requirements.in
  venv/bin/pip-compile --strip-extras --upgrade --output-file=requirements/qa/requirements.txt requirements/runtime/requirements.txt requirements/qa/requirements.in
  venv/bin/pip-compile --strip-extras --upgrade --output-file=requirements/dev/requirements.txt requirements/qa/requirements.txt requirements/dev/requirements.in

  venv/bin/pip install -r requirements/dev/requirements.txt
}

test() {
  venv/bin/coverage run -m pytest -v test_reload_schema.py

  venv/bin/coverage report -m

  venv/bin/coverage html
}

run_linters() {
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
