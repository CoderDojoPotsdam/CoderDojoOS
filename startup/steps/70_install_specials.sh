#!/bin/bash

source "$configuration"

here="`dirname \"$0\"`"

specials_folder="$here/../../specials"

specials="`use_case_file specials-to-install.txt cat`"

for special in $(echo "$specials" | grep -vE "^\s*#" | tr "\n" " ")
do
  special_location="$specials_folder/$special"
  if ! [ -d "$special_location" ]
  then
    2>&1 echo "ERROR: special \"$special\" not found at \"$special_location\""
    continue
  fi
  install_sh_file="$special_location/install.sh"
  if ! [ -f "$install_sh_file" ]
  then
    2>&1 echo "ERROR: special \"$special\" does not have in installation file:"
    2>&1 echo "ERROR: There should be one: $install_sh_file"
    continue
  fi
  echo "***************** installing special *****************"
  echo "* name: $special"
  echo "* location: $install_sh_file"
  echo "*"
  "$install_sh_file"
done
