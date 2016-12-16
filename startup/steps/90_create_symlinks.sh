#!/bin/bash

source "$configuration"


function folder() {
  current_location="$1"
  type="folder"
}

function file() {
  current_target="$1"
  type="file"
}

function link() {
  link_name="$1"
  if [ -z "$current_target" ]
  then
    1>&2 (
      echo "ERROR: first use path, then link!"
    )
    return 1
  fi
  if [ -e "$link_name" ] && ! [ -L "$link_name" ]
  then
    # if the file or directory exists and is not a symbolic link
    # we copy it to the target
    cp -rf "$link_name" "$current_target"
    rm -rf "$link_name"
  elif [ -L "$link_name" ] && \
       [ "$current_target" == "`readlink -n \"$link_name\"`" ]
  then
    echo "Link exists: $link_name -> $current_target"
  fi
  if ln -s -T "$current_target" "$link_name"
  then
    echo "New link: $link_name -> $current_target"
  else
    1>&2 echo "ERROR: could not create link from $link_name to $current_target."
  fi
}

use_case_file sym-links.config collect_symlinks
