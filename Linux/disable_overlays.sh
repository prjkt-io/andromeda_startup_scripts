#!/bin/bash
echo "Overlay Disabler Shell Script by [projekt.] development team"
echo ""
echo "Make sure the device is connected and ADB option enabled"
echo "Please only have one device connected at a time to use this!"
echo ""

CL_RST="\033[0m"
CL_YLW="\033[01;33m"

# Get the current directory of the device running this script
ROOT=$(dirname "${0}")

# ADB specific commands for termination
# Don't kill existing servers in case someone has
# a wireless ADB setup going.
# adb kill-server
adb start-server

# Device configuration of the testing rack
ADB="adb"

echo -e "${CL_YLW} Disabling overlays ${CL_RST}"
for item in $("${ROOT}/${ADB}" shell cmd overlay list | grep '\[x\]' | sed 's/\[x\]//');do echo ${item} && "${ROOT}/${ADB}" shell cmd overlay disable ${item};done
