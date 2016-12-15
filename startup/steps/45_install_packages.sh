#!/bin/bash

source "$configuration"
packages="`use_case_file \"packages-to-install.txt\" \"cat\"`"

# we assume super user previleges

for package in $(echo "$packages" | grep -vE "^\s*#" | tr "\n" " ")
do
  # http://askubuntu.com/questions/252734/apt-get-mass-install-packages-from-a-file#252735
  apt-get -y -qq install $package
done

apt-get -y -f install
sudo apt-get -y -qq upgrade
