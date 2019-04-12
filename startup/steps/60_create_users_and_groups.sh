#!/bin/bash
#
# This file creates the users on the system.
#

source "$configuration"

default_shell="/bin/bash"

_password_is_set=true
function error_if_no_password() {
  if [ -z "_password_is_set" ]
  then
    1>&2 echo "ERROR: user $_current_user has no password."
  fi
}

function user() {
  error_if_no_password
  _current_user="$1"
  _password_is_set=
  useradd -m -d "/home/$_current_user" "$_current_user"
  if grep -q "$default_shell" /etc/shells; then
    chsh -s "/bin/bash" "$_current_user"
    echo "Set default shell of $_current_user to \"$default_shell\"."
  fi
}

function password() {
  if [ -z "$_current_user" ]
  then
    1>&2 echo "ERROR: Please call 'user' before you call password."
  else
    # from http://stackoverflow.com/questions/27837674/changing-a-linux-password-via-script#27838781
    echo "$_current_user:$1" | chpasswd
    _password_is_set=true
  fi
}


function group() {
  groups "$@"
}

function groups() {
  for group in "$@"
  do
    groupadd -f "$group"
    # from https://www.cyberciti.biz/faq/howto-linux-add-user-to-group/
    # changed useradd to usermod because that works
    if usermod -aG "$group" "$_current_user"; then
      echo "Added $_current_user to group $group."
    else
      echo "ERROR adding $_current_user to group $group."
    fi
  done
}

#
# Create an autologin information for a user
#
function autologin() {
  local user="$1"
  mkdir -p '/usr/share/lightdm/lightdm.conf.d'
  # from https://ubuntu-mate.community/t/auto-login-to-the-desktop/60
  (
    echo "[SeatDefaults]"
    echo "greeter-session=lightdm-gtk-greeter"
    echo "autologin-user=$user"
  ) > '/usr/share/lightdm/lightdm.conf.d/60-autologin.conf'
}

use_case_file "users.config"

error_if_no_password



