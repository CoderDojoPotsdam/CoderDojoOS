#!/bin/bash
#
# For maintainers:
# go to https://www.jetbrains.com/pycharm/download/download-thanks.html
# to find the latest version
pycharm_version="2017.2.3"


cd "`dirname \"$0\"`"
# all variables we need to configure the script
pycharm_archive_url="https://download-cf.jetbrains.com/python/pycharm-community-$pycharm_version.tar.gz"
pycharm_temp_folder="/tmp/pycharm"
pycharm_archive="/tmp/pycharm-community-$pycharm_version.tar.gz"
pycharm_folder="/opt/pycharm"
pycharm_version_file="$pycharm_folder/VERSION"

if ! type realpath
then
  apt-get -y -qq install realpath
fi

echo "install icon"
cp --update ./jetbrains-pycharm-ce.desktop /usr/share/applications

if [ -d "$pycharm_folder" ] && [ -f "$pycharm_version_file" ] && [ "`cat \"$pycharm_version_file\"`" == "$pycharm_version" ]
then
  echo "Pycharm already installed."
  exit 0
fi

echo "create the folder $pycharm_temp_folder"
rm -rf "$pycharm_temp_folder"
mkdir -p "$pycharm_temp_folder"

echo "download pycharm"
wget -q -O "$pycharm_archive" "$pycharm_archive_url" || {
  echo "downloading PyCharm failed." ;
  exit 1;
}

# could add owner to tar
# --owner "$UPDATE_USERNAME"

echo unpack pycharm
( cd "$pycharm_temp_folder" && tar -zxf "$pycharm_archive" ; ) || {
  echo "Error unpacking PyCharm";
  exit 2;
}

echo "remove the archive so only one folder is left in $pycharm_temp_folder"
rm "$pycharm_archive"

echo "move everything to $pycharm_folder"
rm -rf "$pycharm_folder"
mv "$pycharm_temp_folder"/* "$pycharm_folder"

# set the version
echo -n "$pycharm_version" > "$pycharm_version_file"
