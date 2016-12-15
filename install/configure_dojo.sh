#!/bin/bash

here="`dirname \"$0\"`"
use_cases="$here/../use-cases"
use_cases_file="$here/../use-cases.txt"
default_use_cases_file="$here/../use-cases.txt"
if [ -f "$use_cases_file" ]
then
  chosen_use_cases="`cat \"$use_cases_file\"`"
else
  chosen_use_cases="`cat \"$default_use_cases_file\"`"
fi

if which realpath 2>>/dev/null 1>>/dev/null
then
  use_cases_file="`realpath \"$use_cases_file\"`"
  use_cases="`realpath \"$use_cases\"`"
fi

function enter_use_cases() {
  echo "Please enter your use-case(s):"
  read _chosen
  chosen_use_cases=""
  error="none"
  for use_case in $_chosen
  do
    if [ -d "$use_cases/$use_case" ]
    then
      chosen_use_cases="$chosen_use_cases $use_case"
    else
      1>&2 echo "ERROR: use-case not found or misspelled: \"$use_case\"."
      error="one"
    fi
  done
  if [ "$error" != "none" ]
  then
    echo -n "Press enter to proceed."
    read _
  fi
}


while true
do
  echo "----------------------------------------------------------"
  if [ -z "$chosen_use_cases" ]
  then
    echo "Your installation is not set up for any use-cases."
  else
    echo "Your installation is currently set up for these use cases:"
    echo "    "$chosen_use_cases
  fi
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
    echo "Possible use-cases:"
    echo
    ls "$use_cases" | grep -vE '^(local|default|.*\.md)$'
    echo
    enter_use_cases
  elif [ "$choice" == "2" ]
  then
    enter_use_cases
  elif [ "$choice" == "3" ]
  then
    break
  else
    echo "Choice \"$choice\" not known."
  fi
done


echo "$chosen_use_cases" > "$use_cases_file"
echo "Use cases are written to $use_cases_file"

