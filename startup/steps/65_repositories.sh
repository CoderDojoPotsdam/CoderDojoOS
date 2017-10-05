#!/bin/bash

source "$configuration"

"$tools/install_package" realpath

_ssh_git="`realpath \"$tools/ssh_git\"`"

use_case_file "ssh.config"

fingerpeint="`ssh-keygen -E md5 -lf \"$ssh_key\" 2>/dev/null || ssh-keygen -lf \"$ssh_key\"`"
echo "ssh_key=$ssh_key fingerprint: $fingerprint"

_there_was_something="false"

_git_location="`which git`"
function _git() {
  export ssh_key="$ssh_key"
  # get fingerprint to allow checks for the right key
  # from https://stackoverflow.com/a/9607373
  echo "GIT_SSH=$_ssh_git $_git_location $@"
  GIT_SSH="$_ssh_git" "$_git_location" "$@"
}

function _default() {
  _in_apply="false"
  _remote=""
  _branch=""
  _owner=""
  _location=""
  _sync="false"
}

function _apply() {
  if [ "$_in_apply" == "true" ]
  then
    1>&2 echo "ERROR: BUG! Somewhere the _apply is used in itself"
    return 1
  fi
  if [ "$_there_was_something" == "false" ]
  then
    echo "Nothing to do."
    return 0
  fi
  if [ -z "$_remote" ]
  then
    1>&2 echo "ERROR: no remote specified. Specify it with git <remote>."
    return 1
  fi
  if [ -z "$_location" ]
  then
    1>&2 echo "ERROR: no location specified. Specify it with location <path>."
    return 1
  fi
  if [ -z "$_owner" ]
  then
    _owner="$default_owner_for_repositories"
  fi
  # Guard clauses end here
  _in_apply="true"
  echo "Repository: $_remote"
  if [ -e "$_location" ]
  then
    if [ ! -d "$_location/.git" ]
    then
      echo "The location $_location has content, removing it."
      rm -rf "$_location"
      _clone
    else
      (
        cd "$_location"
        _choose_branch
        _git pull "$_remote"
        _choose_branch
      )
    fi
  else
    _clone
  fi
  (
    cd "$_location"
    echo "In `pwd`:"
    if [ "$_sync" == "true" ]
    then
      echo "- set user name and email for following operations"
      _git config --global user.name "$git_user_name"
      _git config --global user.email "$git_user_email"

      echo "- synchronize the repository"
      if [ -z "$_sync_message" ]
      then
        _sync_message="$default_sync_message"
      fi
      _git add --all .
      _git commit -m "$_sync_message"
      _git push "$_remote"
    fi
    echo -n "- own the repository by $_owner ... "
    if chown -R "$_owner" .
    then
      echo "ok"
    else
      echo "fail"
    fi
  )
  _default
}

function _clone() {
  mkdir -p "$_location"
  (
    cd "$_location"
    _git clone "$_remote" .
    _choose_branch
  )
}

function _choose_branch() {
  if [ -z "$_location" ]
  then
    1>&2 echo "ERROR: want to choose branch but there is no location."
    return 1
  fi
  (
    cd "$_location"
    if [ -n "$_branch" ]
    then
      _git checkout "$_branch"
    fi
  )
}

function git() {
  _apply
  _there_was_something="true"
  _remote="$1"
}

function branch() {
  _there_was_something="true"
  _branch="$1"
}

function owner() {
  _there_was_something="true"
  _owner="$1"
}

function location() {
  _there_was_something="true"
  _location="$1"
}

function sync() {
  _sync="true"
  _sync_message="$1"
}

_default

use_case_file "repositories.config"

_apply
