#!/usr/bin/env bash
dirs=$*
exit_code=0
changed_files=$(git  diff --name-only ${CI_COMMIT_BEFORE_SHA}...${CI_COMMIT_SHA})
failed_files=""
#changed_files=$(git  diff --name-only -r ${CI_COMMIT_SHA})

echo "Safe paths: ${dirs}"
echo
echo "Changed files in MR:\n$changed_files"
echo
for file in $changed_files; do
  for dir in $dirs; do
    grep "^\${dir}" $file
    if [ "$?" != "0" ]; then
      exit_code=1
      failed_files += $file
    fi
  done
done

echo "Changed files not in safe paths:\n$failed_files"

exit $exit_code
