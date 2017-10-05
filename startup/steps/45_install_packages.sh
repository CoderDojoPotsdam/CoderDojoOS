#!/bin/bash

source "$configuration"
packages="`use_case_file \"packages-to-install.txt\" \"cat\"`"

# we assume super user previleges

# update sources
apt-get update

fix_apt

for package in $(remove-comments "$packages")
do
  # http://askubuntu.com/questions/252734/apt-get-mass-install-packages-from-a-file#252735
  apt-get -y -qq install $package
done

fix_apt

apt-get -y -qq upgrade
