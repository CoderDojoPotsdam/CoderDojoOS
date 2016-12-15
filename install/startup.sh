#!/bin/bash

if ! which realpath 1>>/dev/null 2>>/dev/null
then
  sudo apt-get -q install realpath || exit 1
fi
here="`dirname \"$0\"`"
here="`realpath \"$here\"`"
startup="`realpath \"$here/../startup/startup.sh\"`"

(
  sudo crontab -l -u root 2>>/dev/null
  echo "@reboot \"$startup.sh\""
) | sudo crontab -u root -
