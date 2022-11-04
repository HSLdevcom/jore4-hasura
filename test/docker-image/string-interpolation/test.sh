#!/bin/bash

set -Eeuo pipefail

# Change directory here.
cd "$(dirname -- "$0")"

expected_stdout_path='./expected-stdout'
expected_stderr_path='./expected-stderr'
expected_exit_status_path='./expected-exit-status'
secrets_dir='./secrets'
migrations_dir='./migrations'

script_name='replace-placeholders-in-sql-schema-migrations.sh'
script_path="../../../../scripts/${script_name}"

secrets_dir_in_docker='/run/secrets'
migrations_dir_in_docker='/migrations'
script_dir_in_docker='/script'

docker_tag='hsldevcom/jore4-hasura:hasura-for-testing-string-interpolation'
# Use our Dockerfile to get the expected shell.
dockerfile_path='../../../hasura.Dockerfile'
docker_context_path='../../..'
entrypoint='/bin/sh'

cleanup() {
  # Removes the Docker image only if this is the only tag for it.
  docker inspect "${docker_tag}" >/dev/null 2>&1 \
    && docker image rm "${docker_tag}" >/dev/null
  [ -z "${test_run_dir+dummy}" ] || rm -rf "${test_run_dir}"
}
trap cleanup EXIT

echo 1>&2 "Starting string interpolation tests."

docker build -q -f "${dockerfile_path}" -t "${docker_tag}" "${docker_context_path}" >/dev/null

# Run tests on copies in a temporary directory.
test_run_dir="$(mktemp -d)"
test_run_secrets_dir="${test_run_dir}/secrets"
test_run_migrations_dir="${test_run_dir}/migrations"
test_run_script_dir="${test_run_dir}/script"
test_run_script_expected_stdout_path="${test_run_dir}/expected-stdout"
test_run_script_expected_stderr_path="${test_run_dir}/expected-stderr"
test_run_script_stdout_path="${test_run_dir}/stdout"
test_run_script_stderr_path="${test_run_dir}/stderr"
test_run_script_stdout_diff_path="${test_run_dir}/stdout-diff"
test_run_script_stderr_diff_path="${test_run_dir}/stderr-diff"

run_tests_in_directory() {
  local test_directory="$1"

  echo 1>&2 ""
  echo 1>&2 "Test $(basename "${test_directory}"):"

  cd "${test_directory}"

  local expected_exit_status
  expected_exit_status="$(cat "${expected_exit_status_path}")"

  cp -ar "${secrets_dir}" "${test_run_secrets_dir}"
  cp -ar "${migrations_dir}" "${test_run_migrations_dir}"
  mkdir -p "${test_run_script_dir}"
  cp -a "${script_path}" "${test_run_script_dir}"
  cp -a "${expected_stdout_path}" "${test_run_script_expected_stdout_path}"
  cp -a "${expected_stderr_path}" "${test_run_script_expected_stderr_path}"

  # Run the script and retain the exit status for error messages.
  set +e
  docker run \
    --rm \
    --volume "${test_run_secrets_dir}:${secrets_dir_in_docker}" \
    --volume "${test_run_migrations_dir}:${migrations_dir_in_docker}" \
    --volume "${test_run_script_dir}:${script_dir_in_docker}" \
    --entrypoint "${entrypoint}" \
    "${docker_tag}" \
    "${script_dir_in_docker}/${script_name}" \
    "${secrets_dir_in_docker}" \
    "${migrations_dir_in_docker}" \
    1>"${test_run_script_stdout_path}" \
    2>"${test_run_script_stderr_path}"
  local err="$?"
  set -e

  # Check stderr.
  if ! diff \
    "${test_run_script_expected_stderr_path}" \
    "${test_run_script_stderr_path}" \
    >"${test_run_script_stderr_diff_path}"; then
    cat <<EOM 1>&2
Expected stderr:
$(cat "${test_run_script_expected_stderr_path}")

Got stderr:
$(cat "${test_run_script_stderr_path}")

diff:
$(cat "${test_run_script_stderr_diff_path}")"
EOM
    exit 1
  fi

  # Check stdout.
  if ! diff \
    "${test_run_script_expected_stdout_path}" \
    "${test_run_script_stdout_path}" \
    >"${test_run_script_stdout_diff_path}"; then
    cat <<EOM 1>&2
Expected stdout:
$(cat "${test_run_script_expected_stdout_path}")

Got stdout:
$(cat "${test_run_script_stdout_path}")

diff:
$(cat "${test_run_script_stdout_diff_path}")"
EOM
    exit 1
  fi

  # Check results.
  find "${test_run_migrations_dir}" -type f -name '*.sql' -print0 \
    | while IFS= read -r -d '' sql_file; do
      diff "${sql_file}.expected" "${sql_file}"
    done

  # Check exit status.
  [ "${err}" -ne "${expected_exit_status}" ] && {
    echo 1>&2 "Expected exit status ${expected_exit_status}"
    echo 1>&2 "Got exit status ${err}"
    exit 1
  }

  # Empty the temporary directory for the next test.
  find "${test_run_dir}" -mindepth 1 -delete

  echo "Success."

  cd ..
}

# Run tests.
find . -mindepth 1 -maxdepth 1 -type d \
  | LC_ALL=C sort \
  | while IFS= read -r test_directory; do
    run_tests_in_directory "${test_directory}"
  done
