#!/bin/bash

v=$1

# Skip if it already exists in maven cache
if [ ! -e "~/.m2/repository/org/cyanogenmod/gello/$v/gello-$v.apk" ]; then
  rm -rf ~/.m2/repository/org/cyanogenmod/gello
  mkdir -p ~/.m2/repository/org/cyanogenmod/gello/$v
  for f in gello-$v.apk gello-$v.apk.sha1; do
    wget https://github.com/LineageOS/android_packages_apps_Gello/releases/download/$v/$f -O ~/.m2/repository/org/cyanogenmod/gello/$v/$f
  done
fi
