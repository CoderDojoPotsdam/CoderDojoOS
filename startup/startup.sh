#!/bin/bash

# use a lock file to prevent several instances runnning in parallel
# from http://unix.stackexchange.com/a/22047/27328
lockfile=/tmp/coderdojoos.lock
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null; then
  trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT
  # do stuff here
  function remove_lock() {
    # clean up after yourself, and release your trap
    rm -f "$lockfile"
    trap - INT TERM EXIT
  }
else
  echo "Lock Exists: $lockfile owned by $(cat $lockfile)"
  exit 1
fi


here="`dirname \"$0\"`"
export coderdojoos_root="$here/.."
export configuration="$coderdojoos_root/configuration/configuration.sh"
_PATH="/root/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
if [ -z "$PATH" ]
  export PATH="$_PATH"
else
  export PATH="$_PATH:$PATH"
fi

source "$configuration"
use_case_file "startup.config"

status="$startup_log_files/status.log"
current_output="$startup_log_files/current.log"
joined_output="$startup_log_files/all.log"

echo "Logs go to $startup_log_files"

(
  echo "Starting up `date`" > "$status"
  echo "======================================================"
  echo "= date: `date`"
  echo "= git commit `git log --pretty=oneline -1`"
  echo
  steps_folder="$here/steps"
  if [ -n "$1" ]
  then
    # Use arguments as steps
    steps="$@"
  else
    steps="`ls \"$steps_folder\"`"
  fi
  echo "Executing steps"
  for step in $steps
  do
    echo "- $step" 
  done
  for step in $steps
  do
    echo -n "Step $step ..." >> "$status"
    echo "+-----------------------------------------------------"
    echo "| Step: $step"
    echo "+"
    if "$steps_folder/$step" 2>&1 | tee "$startup_log_files/current_$step.log" | tee -a "$startup_log_files/all_$step.log"
    then
      echo " ok" >> "$status"
    else
      echo " fail" >> "$status"
    fi
  done
  echo "Done." >> "$status"
  echo ""
  echo "CoderDojoOS startup done."
) 2>&1 | tee "$current_output" | tee -a "$joined_output"


remove_lock
