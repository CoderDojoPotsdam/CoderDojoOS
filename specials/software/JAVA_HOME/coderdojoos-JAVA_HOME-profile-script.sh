#!/bin/bash

# according to
#   https://help.ubuntu.com/community/EnvironmentVariables

export JAVA_HOME="/usr/lib/jvm/` ls /usr/lib/jvm | grep default | head -n1 `"
export PATH="$PATH:$JAVA_HOME/bin"
