#!/bin/bash

set -eu

# Merge HSL-specific metadata with generic metadata
# 1. If the file with the same name already exists both in the generic and in the HSL metadata,
# then the HSL version will be merged into the generic one
# 2. If the file in the HSL metadata does not exist in the generic one, it will be copied
#
# Note: these need to be absolute paths.
SOURCE_DIR="$1"
DESTINATION_DIR="$2"

cd "$SOURCE_DIR"
for SOURCE_YAML_FILE in `find . -name "*.yaml"`
do
  if [ -f "$DESTINATION_DIR/$SOURCE_YAML_FILE" ]; then
    # if the file with the same name already exists -> merge them
    echo "Merging yaml file: $SOURCE_YAML_FILE"

    # note: cannot use yq's ireduce as it requires a base value to be set. If setting
    # {}, it cannot merge arrays; if setting [], it cannot merge objects
    PATCH_FILE="$SOURCE_DIR/$SOURCE_YAML_FILE" \
      yq eval -i '. *+ load(env(PATCH_FILE))' "$DESTINATION_DIR/$SOURCE_YAML_FILE"
  else
    # if the file does not exist yet -> copy it
    echo "Copying yaml file: $SOURCE_YAML_FILE"
    cp "$SOURCE_DIR/$SOURCE_YAML_FILE" "$DESTINATION_DIR/$SOURCE_YAML_FILE"
  fi
done

for SOURCE_GRAPHQL_FILE in `find . -name "*.graphql"`
do
 if [ -f "$DESTINATION_DIR/$SOURCE_GRAPHQL_FILE" ]; then
    # if the file with the same name already exists -> merge them (= just concatenate the file contents)
    echo "Merging graphql file: $SOURCE_GRAPHQL_FILE"

    echo "" >> $DESTINATION_DIR/$SOURCE_GRAPHQL_FILE
    cat $SOURCE_DIR/$SOURCE_GRAPHQL_FILE >> $DESTINATION_DIR/$SOURCE_GRAPHQL_FILE
  else
    # if the file does not exist yet -> copy it
    echo "Copying graphql file: $SOURCE_GRAPHQL_FILE"
    cp "$SOURCE_DIR/$SOURCE_GRAPHQL_FILE" "$DESTINATION_DIR/$SOURCE_GRAPHQL_FILE"
  fi
done
