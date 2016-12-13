#!/bin/bash
#
# The configuration of the CoderDojoOS
# ====================================

# Files and Locations
# -------------------
#
# The directory of the git repository
if [ -z "coderdojoos_root" ]
then
  coderdojoos_root="/opt/coderdojoos"
fi
# The location of the configuration
coderdojoos_configuration="$coderdojoos_root/configuration"
# The use-cases
coderdojoos_use_cases="$coderdojoos_root/use-cases.txt"
# The default use cases if no were found
coderdojoos_use_cases_default="$coderdojoos_root/use-cases-default.txt"
# The directory where all use-cases can be found
coderdojoos_use_cases_directory="$coderdojoos_root/use-cases"


# Users and Roles
# ---------------
#
# The user group for all users with write access to the coderdojo os
coderdojoos_group="coderdojoos"

# Configuration for Use Cases
# ---------------------------
#
# To enable a fast configuration for special use cases,
# the configuration of these is loaded at the end.
#
# The list of all use cases
if [ -f "$coderdojoos_use_cases" ]
then
  coderdojoos_use_cases="`cat \"$coderdojoos_use_cases"`"
else
  coderdojoos_use_cases="`cat \"$coderdojoos_use_cases_default"`"
fi

# This function loads the configuration from the use cases
#
# $1 - the file to find
# $2 the action to do. default=source
function use_case_file() {
  action="$2"
  if [ -z "$action" ]
  then
    action="source"
  fi
  for use_case in default $coderdojoos_use_cases
  do
    file="$coderdojoos_use_cases_directory/$use_case/$1"
    if [ -f "$file" ]
    then
      1>&2 echo "Loading configuration file: $action $file"
      "$action" "$file"
    fi
  done
  action=
  file=
}

use_case_file "configuration.sh"

# Requirements
# ============
#
# Some steps require commands and some steps require packages to be installed
#
# Make sure a command is available and exit if not
function require_commands() {
  unknown_commands=""
  for command in "$@"
  do
    if ! which "$command" 2>>/dev/null 1>>/dev/null
    then
      unknown_commands="$command $unknown_commands"
    fi
  done
  if [ -n "$unknown_commands" ]
  then
    echo "Commands not known: $unknown_commands"
    echo "Exiting with error"
    exit 1
  fi
}
function require_command() {
  require_commands "$@"
}


