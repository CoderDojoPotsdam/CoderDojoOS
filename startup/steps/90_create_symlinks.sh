#!/bin/bash

source "$configuration"

"$tools/install_package" realpath

# The first parameter is the string to remove the slash from.
function remove_last_slash() {
  local string="$1"
  # from http://stackoverflow.com/questions/17542892/how-to-get-the-last-character-of-a-string-in-a-shell#21635778
  while [ "${string: -1}" == "/" ]
  do
    local string="${string:0:-1}"
  done
  if [ -z "$string" ]
  then
    echo "/"
  else
    echo "$string"
  fi
}

function folder() {
  current_target="`remove_last_slash \"$1\"`"
}

function file() {
  current_target="`remove_last_slash \"$1\"`"
}

function link() {
  link_name="`remove_last_slash \"$1\"`"
  if [ -z "$current_target" ]
  then
    1>&2 echo "ERROR: first use path, then link!"
    return 1
  fi
  if [ -L "$link_name" ]
  then
    existing_target="`readlink -n \"$link_name\"`"
    if [ "`realpath \"$current_target\"`" == "`realpath \"$existing_target\"`" ]
    then
      echo "Link exists: \"$link_name\" -> \"$current_target\""
      return 0
    else
      echo "Removing link \"$link_name\" pointing to \"$existing_target\""
      rm -f "$link_name"
    fi
  fi
  if [ -e "$link_name" ] && ! [ -L "$link_name" ]
  then
    # if the file or directory exists and is not a symbolic link
    # we copy it to the target
    cp -rf "$link_name" "$current_target"
    rm -rf "$link_name"
  fi
  if ln -s -T "$current_target" "$link_name"
  then
    echo "New link: \"$link_name\" -> \"$current_target\""
  else
    1>&2 echo "ERROR: could not create link from \"$link_name\" to \"$current_target\"."
  fi
}

use_case_file sym-links.config
