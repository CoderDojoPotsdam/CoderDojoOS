#!/bin/bash
#
# Update all git repositories.
#

source "$configuration"
require_command "filename" "git"
use_case_file "update.config"

(
  cd "$coderdojoos_root"
  git pull "$update_from" master
)
