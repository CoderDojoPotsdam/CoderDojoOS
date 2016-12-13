#!/bin/bash
# wait for an internet connection

# while loop
# http://bash.cyberciti.biz/guide/While_loop

routesToTheInternet=0

echo -n "Checking for an internet connection "

while [ $routesToTheInternet -eq 0 ]
do
  # check for an internet connection
  # http://stackoverflow.com/questions/1406644/checking-internet-connection-with-command-line-php-on-linux
  # routesToTheInternet=`/sbin/route -n | grep -c '^0\.0\.0\.0'`
  # does not work

  # check explicitely for github
  if wget --quiet -O- https://github.com >> /dev/null 2>>/dev/null
  then
    routesToTheInternet=1
  else
    routesToTheInternet=0

    # wait some time
    # http://www.unix.com/shell-programming-and-scripting/42396-wait-5-seconds-shell-script.html
    sleep 1
    echo -n "."
  fi
done

echo " connected."
