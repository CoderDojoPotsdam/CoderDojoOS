#!/bin/bash

source "$configuration"

here="`dirname \"$0\"`"

specials_folder="$here/../../specials"

specials="`use_case_file specials-to-install.txt cat`"

for special in $(remove-comments "$specials")
do
  special_location="$specials_folder/$special"
  if ! [ -d "$special_location" ]
  then
    2>&1 echo "ERROR: special \"$special\" not found at \"$special_location\""
    continue
  fi
  run_offline_sh_file="$special_location/run_offline.sh"
  if ! [ -f "$run_offline_sh_file" ]
  then
    2>&1 echo "NOTICE: special \"$special\" does not have in run_offline file:"
    2>&1 echo "NOTICE: If there was one, it should be: $run_offline_sh_file"
    continue
  fi
  echo
  echo "***************** starting offline special *****************"
  echo "* name: $special"
  echo "* location: $run_offline_sh_file"
  echo "*"
  "$run_offline_sh_file"
done
