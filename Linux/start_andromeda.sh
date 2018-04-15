#!/bin/bash
echo "Andromeda Start Shell Script by [projekt.] development team"
echo ""
echo "This requires projekt.andromeda to be installed on the device"
echo "Make sure the device is connected and ADB option enabled"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
echo ""
echo ""

# Get the current directory of the device running this script
ROOT=$(dirname $0)

# custom adb command supporting serials
adbm="adb"

# Make sure our adb has correct permissions
chmod +x $ROOT/adb

# ADB specific commands for termination
$ROOT/$adbm kill-server

echo ""
if [ $($ROOT/$adbm devices | wc -l </dev/null) > 4 ]; then
    echo "It seems that you have multiple devices connected"
    echo "Please provide your device's android serial (\$ANDROID_SERIAL)"
    echo "before proceeding"
    echo ""
    read -p "Enter your device's serial: " serial
    echo ""

    adbm="adb -s "$serial""
fi

# Setting our customized adb shell
ADBS="$adbm shell"

# Let's first grab the location where Andromeda is installed
pkg=$($ROOT/$ADBS pm path projekt.andromeda)

# Due to the way the output is formatted, we have to strip 10 chars at the start
pkg=$(echo $pkg | cut -d : -f 2 | sed s/\\r//g)

# Now let's kill the running Andromeda services on the mobile device
kill=$($ROOT/$ADBS pidof andromeda)

# Check if we need to kill the existing pids, then kill them if need be
if [[ "$kill" != "" ]]; then
$ROOT/$ADBS kill -9 $kill
fi
echo
$ROOT/$ADBS << EOF
am force-stop projekt.substratum
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH=$pkg app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
echo "Please remove your device from the computer!"
exit
EOF

# We're done!
$ROOT/$adbm kill-server
