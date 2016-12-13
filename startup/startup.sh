#!/bin/bash

here="`dirname \"$0\"`"
export coderdojoos_root="$here/.."
export configuration="$coderdojoos_root/configuration/configuration.sh"

source "$configuration"
use_case_file "startup.sh"

status="$startup_log_files/status.log"
current_output="$startup_log_files/current.log"
joined_output="$startup_log_files/all.log"

echo "Logs go to $startup_log_files"

(
  echo "Starting up" > "$status"
  steps="$here/steps"
  for step in `ls "$steps"`
  do
    echo -n "Step $step ..." >> "$status"
    if "$steps/$step" 2>&1 | tee "$startup_log_files/current_$step.log" | tee -a "$startup_log_files/all_$step.log"
    then
      echo " ok" >> "$status"
    else
      echo " fail" >> "$status"
    fi
  done
  echo "Done." >> "$startup"
) 2>&1 | tee "$current_output" | tee -a "$joined_output"
