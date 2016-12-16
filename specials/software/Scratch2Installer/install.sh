#!/bin/bash

cd "`dirname \"$0\"`"

# only copy the installer if Scratch2 is not installed

if [ ! -f '/opt/Scratch 2/bin/Scratch 2' ]
then
  cp --update ./scratch-2-installer.desktop /usr/share/applications/
  cp --update ./install_scratch_2.sh /opt/
fi




