#!/bin/bash

cd "`dirname \"$0\"`"

source config

(
  cd "$server_dir"
  source ENV/bin/activate
  echo "Start the server"
  export OFFLINE_BUILD_DIRECTORY="../$offline_build_dir"
  # server is in debug mode so it restarts when there are changes
  ( python3 -m intro_offline_server 1>"../$log_file" 2>>"../$log_file" ) &
  sleep 1 # wait for the server to start
  cat "../$log_file"
)
