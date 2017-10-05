#!/bin/bash

set -e

cd "`dirname \"$0\"`"

source config

echo "Install the required packages."
apt-get -y install python3 git python3-pip realpath

function update_repo() {
  local dir="$1"
  local branch="$2"
  local remote="$3"
  (
    echo "Update $dir from branch $branch from remote $remote"
    set -e
    mkdir -p "$dir"
    cd "$dir"
    if [ -d ".git" ] && git pull; then
      echo "Pulled successfully."
    else
      echo "Error, could not pull. Invalid directory. Cleaning up and retrying."
      rm -rf * .git
      git clone "https://github.com/CoderDojoPotsdam/intro" .
    fi
    if ! [ -d ".git" ]; then
      echo "Could not create a git repository in $dir"
      # This check is necessary so we do not corrupt this coderdojoos repository
      return 1
    fi
    git stash
    git checkout "$branch"
    chmod a+r -R .
  )
}

update_repo "$server_dir" "server" "https://github.com/CoderDojoPotsdam/intro.git"
update_repo "$offline_build_dir" "offline-build" "https://github.com/CoderDojoPotsdam/intro.git"

echo "install local desktop file"
(
  echo "[Desktop Entry]"
  echo "Name=Offline Material"
  echo "Exec=firefox `realpath \"$offline_build_dir\"`/index.html"
  echo "Terminal=false"
  echo "Type=Application"
  echo "Icon=firefox"
  echo "Categories=Development;"
  echo "StartupNotify=true"
) > /usr/share/applications/CoderDojoOS-intro.desktop

echo "install server desktop file"
(
  echo "[Desktop Entry]"
  echo "Name=Offline Material (server)"
  echo "Exec=firefox http://localhost:25444/"
  echo "Terminal=false"
  echo "Type=Application"
  echo "Icon=firefox"
  echo "Categories=Development;"
  echo "StartupNotify=true"
) > /usr/share/applications/CoderDojoOS-intro-server.desktop

(
  set -e
  echo "Install requirements"
  cd "$server_dir"
  pip3 install virtualenv
  if ! [ -d "ENV" ]; then
    virtualenv -p python3 ENV
  fi
  source ENV/bin/activate
  pip install --upgrade -r requirements.txt
)

sleep 1 # wait for a running server to restart
if ! wget -O /dev/null http://localhost:25444/ 2>/dev/null
then
  ./run_offline.sh
fi
