#!/bin/sh
#
# Replace placeholders in SQL schema migrations.
#
# Docker or Kubernetes secrets contain the PostgreSQL users we need in the SQL
# schema migrations. As placeholders in the SQL schema migrations, we use
# mangled Docker secret filenames with bracket delimiters. This script replaces
# the placeholders with the contents of the Docker secrets at runtime.
#
# E.g. the username stored in a secret named
# "db-jore3importer-username" is used with the placeholder
# "xxx_db_jore3importer_username_xxx" within the SQL schema migration
# files.

set -eu

[ "$#" -ne 2 ] && {
  echo 1>&2 "Usage: $(basename "$0") RUNTIME_SECRETS_DIR RUNTIME_MIGRATIONS_DIR"
  exit 1
}

secrets_dir="$1"
migrations_dir="$2"

# Choose delimiters that allow the placeholders to act as valid SQL identifiers
# for any static analysis purposes.
delimiter_alnum='xxx'
start_delimiter="${delimiter_alnum}_"
end_delimiter="_${delimiter_alnum}"
placeholder_characters='0-9A-Za-z_'

cleanup() {
  [ -z "${check_duplicate_list+dummy}" ] || rm -f "${check_duplicate_list}"
  [ -z "${sed_script_file+dummy}" ] || rm -f "${sed_script_file}"
}
trap cleanup EXIT

check_duplicate_list="$(mktemp)"
sed_script_file="$(mktemp)"

# Create a script file for sed to replace the placeholders.
write_to_sed_script_file() {
  secret_path="$1"
  # As `basename -z` is not supported by the available shell, we cannot handle
  # newlines in filenames with this approach. We do not translate the newline
  # inserted by basename.
  placeholder="$(
    basename "${secret_path}" \
      | tr -C "${placeholder_characters}\n" '_'
  )"

  # Check for the delimiter in the secret name.
  if echo \
    "${placeholder}" \
    | grep \
      -q \
      -e "${delimiter_alnum}"; then
    cat <<EOM 1>&2
The basename for secret
${secret_path}
should not contain the alphanumeric part of the delimiter:
${delimiter_alnum}
EOM
    exit 4
  fi

  # Check for collisions of secrets.
  if grep \
    -q \
    -x \
    -e "${placeholder}" \
    "${check_duplicate_list}"; then
    cat <<EOM 1>&2
The basename for secret
${secret_path}
is not unique enough. The basenames of the secrets should differ by alphanumeric
characters.
EOM
    exit 2
  fi
  echo "${placeholder}" >>"${check_duplicate_list}"

  echo "s|${start_delimiter}${placeholder}${end_delimiter}|$(cat "${secret_path}")|g" \
    >>"${sed_script_file}"
}

# Replace the placeholders with sed and check for leftover placeholders.
replace_and_check() {
  migration_path="$1"
  sed \
    -f "${sed_script_file}" \
    -i \
    "${migration_path}"
  if leftover_placeholders="$(
    grep \
      -o \
      -h \
      -E \
      -e "${start_delimiter}[${placeholder_characters}]+${end_delimiter}" \
      "${migration_path}"
  )"; then
    sorted_leftovers="$(echo "${leftover_placeholders}" | sort -u)"
    cat <<EOM 1>&2
The migration file
${migration_path}
contains some placeholders for which there are no corresponding secrets. The
offending placeholders are:
${sorted_leftovers}
EOM
    exit 3
  fi
}

echo "Starting to replace placeholders in SQL schema migration files."

# As `export -f` is not supported by the available shell, executing the shell
# functions with `find` does not work.

# As `read -d ''` is not supported by the available shell, `find -print0` cannot
# be used here.

# Loop over secrets.
find "${secrets_dir}" -type f \
  | LC_ALL=C sort \
  | while IFS= read -r file; do
    write_to_sed_script_file "${file}"
  done

# Loop over SQL schema migrations.
find "${migrations_dir}" -type f -name '*.sql' \
  | LC_ALL=C sort \
  | while IFS= read -r file; do
    replace_and_check "${file}"
  done

echo "Replacing placeholders done."
