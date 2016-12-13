#!/bin/bash

source "$configuration"
use_case_file "git-remotes.config"

for remote in $remotes
do
  # ${!...} http://stackoverflow.com/questions/1921279/how-to-get-a-variable-value-if-variable-name-is-stored-as-string#1921337
  remote_url="${!remote}"
  (
    cd "$coderdojoos_root"
    git remote remove "$remote" 2>>/dev/null
    git remote add "$remote" "$remote_url"
    echo "Set remote $remote to $remote_url"
  )
done



