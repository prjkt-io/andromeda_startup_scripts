#!/bin/bash
echo "Overlay Uninstaller Shell Script by [projekt.] development team"
echo ""
echo "Make sure the device is connected and ADB option enabled"
echo "Please only have one device connected at a time to use this!"
echo ""

CL_RST="\033[0m"
CL_YLW="\033[01;33m"

# Get the current directory of the device running this script
ROOT="$(cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd)"

# Device configuration of the testing rack
ADB="$(command -v adb)"
if [[ "${ADB}" == "" ]]; then
    ADB="${ROOT}/adb"
fi

# ADB specific commands for termination
# Don't kill existing servers in case someone has
# a wireless ADB setup going.
# adb kill-server
"${ADB}" start-server

if [[ ! "${@}" =~ --skip-disabled ]]; then
echo -e "${CL_YLW}Uninstalling disabled overlays${CL_RST}"
for item in $("${ADB}" shell cmd overlay list | grep '\[ \]' | sed 's/\[ \]//');do echo "${item}" && "${ADB}" shell pm uninstall "${item}";done
fi

if [[ ! "${@}" =~ --skip-enabled ]]; then
echo -e "${CL_YLW}Uninstalling enabled overlays${CL_RST}"
for item in $("${ADB}" shell cmd overlay list | grep '\[x\]' | sed 's/\[x\]//');do echo "${item}" && "${ADB}" shell pm uninstall "${item}";done
fi

if [[ ! "${@}" =~ --skip-stuck ]]; then
echo -e "${CL_YLW}Uninstalling pink state overlays${CL_RST}"
for item in $("${ADB}" shell cmd overlay list | grep '\-\-\-' | sed 's/--- //');do echo "${item}" && "${ADB}" shell pm uninstall "${item}";done
fi

echo -e "${CL_YLW}The script will reboot your device in five seconds${CL_RST}"

for i in {5..1}; do
  echo -e "${CL_YLW}Rebooting in ${i} seconds"
  sleep 1
done

echo -e "${CL_YLW}Rebooting${CL_RST}"
"${ADB}" reboot