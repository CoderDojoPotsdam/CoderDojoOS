#!/bin/bash

here="`pwd`/`dirname \"$0\"`"

(
  sudo crontab -l -u root 2>>/dev/null
  echo "@reboot \"$here/../startup/startup.sh\""
) | sudo crontab -u root -
