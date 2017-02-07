#!/bin/bash

coderdojoos_root="/opt/coderdojoos"
coderdojoos_git_url="https://github.com/CoderDojoPotsdam/CoderDojoOS.git"

function action_pull() {
  (
    cd "$coderdojoos_root"
    sudo git pull "$coderdojoos_git_url"
  )
}

function action_clone() {
  sudo rm -rf "$coderdojoos_root"
  sudo mkdir -p "$coderdojoos_root"
  sudo git clone "$coderdojoos_git_url" "$coderdojoos_root"
}

function confirm() {
  while true
  do
    if [ "$1" == "y" ]
    then
      echo -n "[Yes|no] "
      default=0
    else
      echo -n "[yes|No] "
      default=1
    fi
    read answer
    if [ "$answer" == "y" ] || [ "$answer" == "yes" ] || [ "$answer" == "Y" ] || [ "$answer" == "Yes" ]
    then
      return 0
    elif [ "$answer" == "n" ] || [ "$answer" == "no" ] || [ "$answer" == "N" ] || [ "$answer" == "No" ]
    then
      return 1
    elif [ -z "$answer" ]
    then
      return "$default"
    fi
    echo "Please answer either y or n or nothing to choose the capital letter and press enter."
  done
}

echo "---------------------- Installation -----------------------"

echo "Installing git..."
sudo apt-get -y -qq install git


if [ -d "$coderdojoos_root/.git" ]
then
  echo "Should I remove the previous installation at $coderdojoos_root?"
  if confirm n
  then
   action_clone
  else
    action_pull
  fi
else
  action_clone
fi

(
  cd "$coderdojoos_root"
  ./install/install.sh
)
