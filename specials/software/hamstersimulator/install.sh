#!/bin/bash

here="`dirname \"$0\"`"

# This installs the Hamstermodell from the Website
#    http://www.java-hamster-modell.de/simulator.html#download

# using arrays
#    http://www.linuxjournal.com/content/bash-arrays
package_urls=('http://www.java-hamster-modell.de/download/v29/hamstersimulator-v29-03-java8.zip' 
              'http://www.java-hamster-modell.de/download/v29/hamstersimulator-v29-01-java7.zip')
java_versions=('1.8'
               '1.7')
destination_path='/opt/hamstermodell'

mkdir -p "$destination_path"

# check dependencies
if ! type unzip 1>/dev/null 2>/dev/null
then
  echo 'Command "unzip" not found, exiting.'
fi

for i in ${!java_versions[*]}
do
  java_version="${java_versions[$i]}"
  url="${package_urls[$i]}"
  path="$destination_path/$java_version"
  version_path="$path/VERSION"
  version="$url"
  download_file="/tmp/hamstersimulator${java_version}.zip"
  if [ ! -f "$version_path" ] || \
     [ "`cat $version_path 2>/dev/null`" != "$version" ]
  then
    # version file is different or not existent -> create the file
    rm -rf "$path"

    mkdir -p "$path"

    echo "downloading the file $url to $download_file"
    wget -q -O "$download_file" "$url" || {
      echo "ERROR: could not download ${url}."
      continue
    }

    echo unpack the archive "$download_file" to "$path"
    unzip -q "$download_file" -d "$path" || {
      echo "ERROR: could not unpack the archive at $download_file."
      continue
    }

    # this is the last step to verify we did it correctly
    echo "$version" > "$version_path"
  fi
done

# prepare icons
if [ ! -f "$destination_path/hamstersimulator.gif" ]
then
  wget -q -O "$destination_path/hamstersimulator.gif" 'http://www.java-hamster-modell.de/bilder/bild-home.gif' || rm -f "$destination_path"/hamstersimulator.gif
fi

# create executable and icons
cp -u "$here/hamstersimulator.sh" "$destination_path"

cp -u "$here/hamstersimulator.desktop" /usr/share/applications/
cp -u "$here/hamstertutorial.desktop" /usr/share/applications/

echo "Adding users to edit hamstermodell"
# from https://www.cyberciti.biz/faq/ubuntu-add-user-to-group/
groupadd hamstermodell
# from http://unix.stackexchange.com/questions/116070/granting-write-permissions-to-a-group-to-a-folder#116073
chgrp -R hamstermodell "$destination_path"
source "$configuration"

(
  echo "Trying CoderDojoOS users"
  function user() {
    if [ -n "$1" ]
    then
      useradd -G hamstermodell "$1"
    else
      1>&2 echo "ERROR: no user given"
    fi
  }
  function password() {
    echo -n
  }
  function groups() {
    echo -n
  }

  use_case_file "users.config" || {
    1>&2 echo "Could not add CoderDojoOS users."
  }
)
(
  cd "/home"
  for user in *; do
    useradd -G hamstermodell "$user"
  done
)
exit 0
