#!/bin/bash

source "$configuration"

use_case_file "ssh.config"

for file in "$ssh_key" "$ssh_public_key" "$ssh_known_hosts_file"
do
  folder="`dirname \"$file\"`"
  if ! [ -d "$folder" ]
  then
    mkdir -p "$folder"
  fi
done

if ! [ -f "$ssh_key" ]
then
  echo "Creating ssh key."
  ssh-keygen -b 2048 -t rsa -f "$ssh_key" -q -N ""
fi

current_key="`cat \"$ssh_public_key\"`"
should_be="`ssh-keygen -y -f \"$ssh_key\"`"
if [ "$current_key" != "$should_be" ]
then
  echo "Writing public key to $ssh_public_key"
  echo "$should_be" > "$ssh_public_key"
fi

if [ -z "$send_public_keys_to_email" ]
then
  echo "Noone wants to receive emails with public keys."
else
  echo "Sending email if required."
  if [ ! -f "$ssh_key_receivers_file" ] || \
     ! ( cat "$ssh_key_receivers_file" | grep -qx "$send_public_keys_to_email" )
  then
    echo "No email was sent to $send_public_keys_to_email."
    mkdir -p "`dirname \"$ssh_key_receivers_file\"`"
    if "$tools/send_email" "$smtp_server" "$smtp_login" "$smtp_password" \
                           "$email_from" "$send_public_keys_to_email" \
                           "$subject" "$email_program_description" \
                           "$description" "`cat \"$ssh_public_key\"`" \
                           "Here is more information about the computer:" \
                           "`dmidecode -t1`"
    then
      echo "Email sent to \"$send_public_keys_to_email\"."
      echo "$send_public_keys_to_email" >> "$ssh_key_receivers_file"
    else
      echo "ERROR: could not send public key to \"$send_public_keys_to_email\"."
    fi
  else
    echo "$send_public_keys_to_email already received the public keys. Not sending them."
  fi
fi

echo "Adding known hosts to the file $ssh_known_hosts_file"
touch "$ssh_known_hosts_file"
(
  cat "$ssh_known_hosts_file"
  for host in $ssh_known_hosts_file
  do
    echo "Adding host $host" 1>&2
    ssh-keyscan -t rsa "$host"
  done
) | sort -u > "$ssh_known_hosts_file"
