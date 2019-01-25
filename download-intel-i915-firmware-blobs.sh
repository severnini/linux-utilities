#!/bin/bash -
#title           : download-intel-i915-firmware-blobs.sh
#description     : This script to download all linux-firmware i915 blobs and put in /lib/firmware/i915/
#author		     : severnini
#date            : 20190125
#version         : 0.1
#usage		     : sudo bash download-intel-i915-firmware-blobs.sh
#notes           : Install Vim and Emacs to use this script.
#bash_version    : 4.4.19(1)-release
#==============================================================================
#Check for sudo
if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

#Get urls
wget -O - https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915 | \
  grep -o '<a class='"'ls-blob bin'"' href=['"'"'"][^"'"'"']*['"'"'"]' | \
  sed -e 's/^<a class='"'ls-blob bin'"' href=["'"'"']//' -e 's/["'"'"']$//' > linux-firmware-i915-blobs.txt

#Complete urls
sed -i -e 's#^#https://git.kernel.org#' linux-firmware-i915-blobs.txt

#Tmp folder
mkdir -p ./linux-firmware-i915-blobs-tmp

#Move urls list
mv linux-firmware-i915-blobs.txt ./linux-firmware-i915-blobs-tmp/linux-firmware-i915-blobs.txt

#Go to tmp folder
cd linux-firmware-i915-blobs-tmp/

#Show urls
cat ./linux-firmware-i915-blobs.txt

#Download urls
wget -i linux-firmware-i915-blobs.txt

#lis dir content
ls

#Move files to firmware folder
mv *.bin /lib/firmware/i915/

#Back one level
cd ..

#Remove files
rm -r linux-firmware-i915-blobs-tmp/
