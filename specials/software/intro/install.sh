#!/bin/bash

set -e

cd "`dirname \"$0\"`"

offline_build_dir="offline-build" # must be relative
server_dir="server"

echo "Install the required packages."
apt-get -y install python3 git python3-pip realpath

echo "Update or clone the server"
mkdir -p "$server_dir"
(
  set -e
  cd "$server_dir"
  git pull || (
    set -e
    rm -rf * .git
    git clone --branch server --depth 1 "https://github.com/CoderDojoPotsdam/intro" .
  )
)

echo "Update or clone the offline build"
mkdir -p "$offline_build_dir"
(
  set -e
  cd "$offline_build_dir"
  git pull || (
    set -e
    rm -rf * .git
    git clone --branch offline-build --depth 1 "https://github.com/CoderDojoPotsdam/intro" .
  )
  chmod a+r -R .
)

echo "install local desktop file"
(
  echo "[Desktop Entry]"
  echo "Name=Offline Material"
  echo "Exec=firefox `realpath \"$offline_build_dir\"`"
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
  echo "Start the server"
  export OFFLINE_BUILD_DIRECTORY="../$offline_build_dir"
  python3 -m intro_offline_server &
)

