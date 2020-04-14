#!/usr/bin/env bash
dirs=$*
exit_code=0
changed_files=$(git  diff --name-only ${CI_COMMIT_BEFORE_SHA}...${CI_COMMIT_SHA})
failed_files=""

echo "Safe paths: ${dirs}"
echo -e "Changed files in MR:\n$changed_files"
for file in $changed_files; do
  for dir in $dirs; do
    echo "$file" | grep "^${dir}" 
    if [ "$?" != "0" ]; then
      exit_code=1
      failed_files+="${file}\n"
    fi
  done
done

echo -e "Changed files not in safe paths:\n$failed_files"

exit $exit_code
