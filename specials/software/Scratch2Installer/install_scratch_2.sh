#/bin/bash

echo run with sudo

# olf file is available at commit 
#   dd09ca065182be2a4000dda45b6aafa3a2500430
# The new file follows this tutorial:
#   http://askubuntu.com/a/120221

cd /tmp

# download Scratch 2
scratch_file=Scratch-437.air
rm -f $scratch_file
wget --quiet https://scratch.mit.edu/scratchr2/static/sa/${scratch_file} & 
scratch_pid=$!

# download adobe air
adobe_file=AdobeAIRInstaller.bin
rm -f ${adobe_file}
wget --quiet http://airdownload.adobe.com/air/lin/download/2.6/${adobe_file} &
adobe_pid=$!

# install packages

apt-get -y -qq install ia32-libs

# Paket ia32-libs ist nicht verfügbar, wird aber von einem anderen Paket referenziert. Das kann heißen, dass das Paket fehlt, dass es abgelöst wurde oder nur aus einer anderen Quelle verfügbar ist.
#Doch die folgenden Pakete ersetzen es:
#  lib32z1 lib32ncurses5 lib32bz2-1.0
apt-get -y -qq install lib32z1 lib32ncurses5 lib32bz2-1.0 

apt-get -y -qq install libgnome-keyring0:i386

# to see the package name, type 
if [ -n "`dpkg --get-selections | grep -v uninstall | grep adobeair`" ]
then
  apt-get remove adobeair
fi

# install adobe air

echo Downloading Adobe Air ... this may take a while.

wait $adobe_pid

if [ ! -f ${adobe_file} ]
then
  echo Error: Could not download Adobe Air.
  # http://www.cyberciti.biz/tips/linux-unix-pause-command.html
  read -p "Press Enter to exit setup." e
  exit 1
fi
chmod +x ${adobe_file}

# find out i386 or amd64
#   http://unix.stackexchange.com/a/12454

if [ -z "`uname -a | grep x86_64`" ]
# install adobe air
then
  echo running i386 installation
  LD_LIBRARY_PATH=/usr/lib/i386-linux-gnu ./${adobe_file}
else
  echo running amd64 installation
  LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu ./${adobe_file} || LD_LIBRARY_PATH=/usr/lib/i386-linux-gnu ./${adobe_file}
fi

# http://stackoverflow.com/questions/19261098/how-to-run-execute-an-adobe-air-file-on-linux-ec2-ubuntu-from-command-line-onl
rm -f /usr/sbin/airinstall
ln -s "/opt/Adobe AIR/Versions/1.0/Adobe AIR Application Installer" /usr/sbin/airinstall

echo Downloading Scratch 2 ... this may take a while.

wait $scratch_pid

if [ ! -f "$scratch_file" ]
then
  echo Error: Could not download Scratch 2.
  # http://www.cyberciti.biz/tips/linux-unix-pause-command.html
  read -p "Press Enter to exit setup." e
  exit 1
fi

echo installing scratch
airinstall `realpath $scratch_file`


