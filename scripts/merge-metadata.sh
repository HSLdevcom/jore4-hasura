#!/bin/sh

# Merge HSL specific metadata with base metadata
base_dir=.$1/databases/default/tables
patch_files=`ls $base_dir/patch/*.yaml | xargs -n 1 basename`
for patch_file in $patch_files
do
  base_path="$base_dir/$patch_file"
  patch_path="$base_dir/patch/$patch_file"
  # tables.yaml does not follow common yaml format, so patch using yq fails.
  # Just append files instead.
  if [ $patch_file = "tables.yaml" ]; then
    cat $patch_path >> $base_path
    continue
  fi
  yq ea -I 0 -i '. as $item ireduce ({}; . *+ $item )' $base_path $patch_path
done