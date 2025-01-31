#!/usr/bin/env bash

set -euo pipefail

# allow running from any working directory
WD=$(dirname "$0")
cd "${WD}/.."

# By default, the tip of the main branch of the jore4-docker-compose-bundle
# repository is used as the commit reference, which determines the version of
# the Docker Compose bundle to download. For debugging purposes, this default
# can be overridden by some other commit reference (e.g., commit SHA or its
# initial substring), which you can pass via the `BUNDLE_REF` environment
# variable.
DOCKER_COMPOSE_BUNDLE_REF=${BUNDLE_REF:-main}

# Define a Docker Compose project name to distinguish the Docker environment of
# this project from others.
export COMPOSE_PROJECT_NAME=jore4-hasura

DOCKER_COMPOSE_CMD="docker compose -f ./docker/docker-compose.yml -f ./docker/docker-compose.custom.yml"

# Download Docker Compose bundle from the "jore4-docker-compose-bundle"
# repository. GitHub CLI is required to be installed.
#
# A commit reference is read from global `DOCKER_COMPOSE_BUNDLE_REF` variable,
# which should be set based on the script execution arguments.
download_docker_compose_bundle() {
  local commit_ref="$DOCKER_COMPOSE_BUNDLE_REF"

  local repo_name="jore4-docker-compose-bundle"
  local repo_owner="HSLdevcom"

  # Check GitHub CLI availability.
  if ! command -v gh &> /dev/null; then
    echo "Please install the GitHub CLI (gh) on your machine."
    exit 1
  fi

  # Make sure the user is authenticated to GitHub.
  gh auth status || gh auth login

  echo "Using the commit reference '${commit_ref}' to fetch a Docker Compose bundle..."

  # First, try to find a commit on GitHub that matches the given reference.
  # This function exits with an error code if no matching commit is found.
  local commit_sha
  commit_sha=$(
    gh api \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "repos/${repo_owner}/${repo_name}/commits/${commit_ref}" \
      --jq '.sha'
  )

  echo "Commit with the following SHA digest was found: ${commit_sha}"

  local zip_file="/tmp/${repo_name}.zip"
  local unzip_target_dir_prefix="/tmp/${repo_owner}-${repo_name}"

  # Remove old temporary directories if any remain.
  rm -fr "$unzip_target_dir_prefix"-*

  echo "Downloading the JORE4 Docker Compose bundle..."

  # Download Docker Compose bundle from the jore4-docker-compose-bundle
  # repository as a ZIP file.
  gh api "repos/${repo_owner}/${repo_name}/zipball/${commit_sha}" > "$zip_file"

  # Extract ZIP file contents to a temporary directory.
  unzip -q "$zip_file" -d /tmp

  # Clean untracked files from `docker` directory even if they are git-ignored.
  git clean -fx ./docker

  echo "Copying JORE4 Docker Compose bundle files to ./docker directory..."

  # Copy files from the `docker-compose` directory of the ZIP file to your
  # local `docker` directory.
  mv "$unzip_target_dir_prefix"-*/docker-compose/* ./docker

  # Remove the temporary files and directories created above.
  rm -fr "$zip_file" "$unzip_target_dir_prefix"-*

  echo "Generating a release version file for the downloaded bundle..."

  # Create a release version file containing the SHA digest of the referenced
  # commit.
  echo "$commit_sha" > ./docker/RELEASE_VERSION.txt
}

start_docker_containers() {
  echo "Running Docker Compose command: $DOCKER_COMPOSE_CMD"

  $DOCKER_COMPOSE_CMD up -d jore4-testdb jore4-auth jore4-tiamat
  $DOCKER_COMPOSE_CMD up --build -d jore4-hasura
}

stop_docker_containers() {
  docker compose --project-name "$COMPOSE_PROJECT_NAME" stop
}

remove_docker_containers() {
  docker compose --project-name "$COMPOSE_PROJECT_NAME" down --volumes
}

print_usage() {
  echo "
  Usage: $(basename "$0") <command>

  start
    Start Docker containers for the dependencies and the Hasura service.

  stop
    Stop all related Docker containers.

  remove
    Stop and remove all related Docker containers.

  help
    Show this usage information.
  "
}

if [[ $# -eq 0 ]]; then
  print_usage
  exit 1
fi

case "$1" in
start)
  download_docker_compose_bundle
  start_docker_containers
  ;;

stop)
  stop_docker_containers
  ;;

remove)
  remove_docker_containers
  ;;

help)
  print_usage
  ;;

*)
  echo ""
  echo "Unknown command: '${1}'"
  print_usage
  exit 1
  ;;
esac
