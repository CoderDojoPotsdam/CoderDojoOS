#!/bin/bash

here="`dirname \"$0\"`"
export coderdojoos_root="$here/.."
export configuration="$coderdojoos_root/configuration/configuration.sh"

source "$configuration"
use_case_file "startup.config"

status="$startup_log_files/status.log"
current_output="$startup_log_files/current.log"
joined_output="$startup_log_files/all.log"

echo "Logs go to $startup_log_files"

(
  echo "Starting up" > "$status"
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
