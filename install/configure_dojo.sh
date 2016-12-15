#!/bin/bash

here="`dirname \"$0\"`"
use_cases="$here/../use-cases"
chosen_use_cases="`cat \"$here/../use-cases-default.txt\" `"
use_cases_file="$here/../use-cases.txt"

while true
do
  echo "Your installation is currently set up for these use cases:"
  echo "    "$chosen_use_cases
  echo "They can be found in the folder"
  echo "    $use_cases"
  echo ""
  echo "What would you like to do?"
  echo " 1  list all possible use-cases"
  echo " 2  specify your use-cases"
  echo " 3  exit"
  echo -n "1 or 2 or 3: "
  read choice
  if [ -z "$choice" ]
  then
    echo "Please enter a choice."
    continue
  elif [ "$choice" == "1" ]
  then
    ls "$use_cases" | grep -iE '^(local|default)$' | less
  elif [ "$choice" == "2" ]
    echo "Please enter your use-case(s):"
    read _chosen
    chosen_use_cases=""
    for use_case in $chosen
    do
      if [ -d "$use_cases/$use_case" ]
      then
        chosen_use_cases="$chosen_use_cases $use_case"
      else
        1>&2 echo "ERROR: use case not found or misspelled: \"$use_case\"."
      fi
    done
  elif [ "$choice" == "3" ]
    break
  else
    echo "Choice \"$choice\" not known."
  fi
done

echo "$chosen_use_cases" > "$use_cases_file"
echo "Use cases are written to $use_cases_file"

