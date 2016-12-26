#/bin/bash

source "$configuration"

use_case_file "offline-server.config"

offline_packages="`use_case_file offline-server.txt cat`"
offline_packages="`remove-comments \"$offline_packages\"`"

if [ -z "`echo \"$offline_packages\" | grep -vE '^[[:space:]]*$'`" ]
then
  echo "No offline-server modules to activate."
  exit 0
fi

if ! [ -d "$offline_server_root/.git" ]
then
  mkdir -p "$offline_server_root"
  git clone "$offline_server_git_https" "$offline_server_root"
  git remote add ssh "$offline_server_git_ssh"
fi

(
  cd "$offline_server_root"
  git pull
  bin/install.sh
  for module in $offline_packages
  do
    bin/modules.sh -a "$module"
  done
)
