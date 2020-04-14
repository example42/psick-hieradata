#!/usr/bin/env bash
dirs=$*
exit_code=0
changed_files=$(git  diff --name-only ${CI_COMMIT_BEFORE_SHA}...${CI_COMMIT_SHA})
#changed_files=$(git  diff --name-only -r ${CI_COMMIT_SHA})

echo "Safe paths: ${dirs}"
echo "Changed files: $changed_files"

for file in $changed_files; do
  for dir in $dirs; do
    grep "^\${dir}" $file || exit_code=1
  done
done

exit $exit_code
