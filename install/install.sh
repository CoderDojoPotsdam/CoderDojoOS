#!/bin/bash

cd "`dirname \"$0\"`"

./startup.sh
./configure_dojo.sh

echo
echo "Setup done. You can restart."
