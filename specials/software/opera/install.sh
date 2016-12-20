#!/bin/bash

# installing opera
# https://help.ubuntu.com/community/OperaBrowser

if type opera >>/dev/null 2>>/dev/null
then
  echo opera is already installed
else
  echo installing opera
  apt-get install debian-archive-keyring

  # add a source
  # http://stackoverflow.com/questions/13195385/aws-ec2-ubuntu-ubuntu-12-04-1-lts-deb-command-not-found
  echo deb http://deb.opera.com/opera/ stable non-free >> /etc/apt/sources.list

  wget -qO - http://deb.opera.com/archive.key | sudo apt-key add -

  apt-get -qq update
  apt-get -y -qq install libstdc++5
  apt-get -y -qq --download-only install opera-stable
  # timeout the install command since opera asks questions although we agree
  timeout 5m apt-get -y -qq install opera-stable

fi
