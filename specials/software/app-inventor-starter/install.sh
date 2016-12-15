#!/bin/sh

# following the tutorial at
# http://appinventor.mit.edu/explore/ai2/linux.html

# to uninstall do
# sudo rm -rf /usr/google/appinventor
# sudo rm -rf ~/.appinventor
# sudp rm -f /usr/share/applications/aiStarter.desktop

here="`dirname \"$0\"`"

# check fr app invntor is installed
if [ -d /usr/google/appinventor ]
then
  echo app inventor is already installed
else
  echo intalling app inventor
  # download the app inventor package
  if [ -d /tmp/app_inventor_setup ]
  then
    rm -r /tmp/app_inventor_setup
  fi
  mkdir /tmp/app_inventor_setup

  cd /tmp/app_inventor_setup

  wget --quiet http://commondatastorage.googleapis.com/appinventordownloads/appinventor2-setup_1.1_all.deb

  echo installing from /tmp/app_inventor_setup/*
  dpkg --install /tmp/app_inventor_setup/*

  cd /

  rm -r /tmp/app_inventor_setup

fi

# https://help.ubuntu.com/community/UnityLaunchersAndDesktopFiles
cp --update "$here"/aiStarter.desktop /usr/share/applications
cp --update "$here"/nolicense/google-app-inventor-icon.jpg \
   '/usr/google/appinventor/commands-for-Appinventor/'
cp --update "$here/start_ai_starter_coderdojoos.sh" "/usr/google/appinventor/commands-for-Appinventor/"

# installing additional packages
# SDL init failure, reason is: No available video device
# http://stackoverflow.com/questions/4841908/sdl-init-failure-reason-is-no-available-video-device
apt-get -y -qq install ia32-libs-sdl
apt-get -y -qq install libsdl1.2debian:i386

# http://stackoverflow.com/a/4909986/1320237
# export DISPLAY=:0
# echo starting app inventor aiStarter. see aiStarter.log

# http://stackoverflow.com/questions/394984/best-practice-to-run-linux-service-as-a-different-user
# daemon --user=$UPDATE_USERNAME "/usr/google/appinventor/commands-for-Appinventor/aiStarter 2>> $UPDATE_DIR/aiStarter.log >> $UPDATE_DIR/aiStarter.log" &

