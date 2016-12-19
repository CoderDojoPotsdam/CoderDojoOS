#!/bin/sh


if type google-chrome >>/dev/null 2>>/dev/null
then
  echo google chrome is already installed
else

  echo installing google chrome

  if [ -d /tmp/google_chrome_setup ]
  then
    rm -r /tmp/google_chrome_setup
  fi

  mkdir /tmp/google_chrome_setup

  cd /tmp/google_chrome_setup 

  # find out if amd64 or i386, default to i386
  if [ -n "`dpkg --get-selections | grep -v deinstall | grep libexif..\\:amd64`" ]
  then
    echo "libexif amd64 installed, downloading the amd64 version of google chrome"
    google_chrome_url=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  else
    if [ -z "`dpkg --get-selections | grep -v deinstall | grep libexif..\\:i386`" ]
    then
      apt-get -y -q install libexif12:i386
    fi
    echo "libexif i386 installed, downloading the i386 version of google chrome"
    google_chrome_url=https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
  fi

  wget --quiet $google_chrome_url \
  ||  { echo "failed to download google chrome" ; exit 1; }

  cd /

  echo installing from /tmp/google_chrome_setup/*

  dpkg --install /tmp/google_chrome_setup/*
  # from http://www.thinkplexx.com/learn/snippet/shell/advanced/automatically-install-dependencies-with-dpkg-i
  if [ "$?" -gt 0 ]
  then
    apt-get -f --force-yes --yes install>/dev/null 2>&1
    dpkg --install /tmp/google_chrome_setup/*
  fi

  rm -r /tmp/google_chrome_setup/

fi
