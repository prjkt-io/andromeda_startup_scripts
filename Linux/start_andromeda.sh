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

# Let's first grab the location where Andromeda is installed
pkg=$("${ADB}" shell pm path projekt.andromeda | sed 's/package://')

# Now let's kill the running Andromeda services on the mobile device
kill=$("${ADB}" shell pidof andromeda)

# Check if we need to kill the existing pids, then kill them if need be
if [[ "${kill}" == "" ]]
then echo
"${ADB}" shell << EOF
am force-stop projekt.substratum
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH="${pkg}" app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
echo "You can now remove your device from the computer!"
exit
EOF
else echo
"${ADB}" shell << EOF
am force-stop projekt.substratum
kill -9 "${kill}"
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH="${pkg}" app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
echo "You can now remove your device from the computer!"
exit
EOF
fi

# We're done!
adb kill-server
