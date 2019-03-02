#!/bin/bash
echo "Andromeda Start Shell Script by [projekt.] development team"
echo ""
echo "This requires projekt.andromeda to be installed on the device"
echo "Make sure the device is connected and ADB option enabled"
echo "Please only have one device connected at a time to use this!"
echo ""

ROOT="$(cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd)"

# Device configuration of the testing rack
ADB="$(command -v adb)"
if [[ ${ADB} == "" ]]; then
    ADB="${ROOT}/adb"
fi

# ADB specific commands for termination
# Don't kill existing servers in case someone has
# a wireless ADB setup going.
# adb kill-server
"${ADB}" start-server

"${ADB}" shell 'pkg=$(pm path projekt.andromeda | head -n1 | cut -d : -f 2 | sed s/\\r//g); CLASSPATH="${pkg}" nohup app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda >/dev/null 2>&1 &'
echo "You can now remove your device from the computer!"
