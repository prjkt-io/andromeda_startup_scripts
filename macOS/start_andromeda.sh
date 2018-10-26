#!/bin/bash
echo "Andromeda Start Script by [projekt.] development team"
echo " "
echo "This requires projekt.andromeda to be installed on the device"
echo "Make sure the device is connected and ADB option enabled"
echo "Please only have one device connected at a time to use this!"
echo " "

# Use bundled ADB
ADB_LOC="./adb"

# check connected device
CUR_DEVICE=$("${ADB_LOC}" devices )
CUR_DEVICE=${CUR_DEVICE:24}
if [[ "$CUR_DEVICE" == "" ]]
then
echo "error: No device detected!"
echo " "
echo "The script will now close. (404)"
sleep 3
echo -e "QUITAPP\n"
fi


# Let's first grab the location where Andromeda is installed
PKG_LOC=$("${ADB_LOC}" shell pm path projekt.andromeda)
if [[ "${PKG_LOC}" != "" ]]
then
echo "Andromeda found! Starting now ..."
else
echo "error: Andromeda not found! Please install Andromeda and try again."
echo " "
echo "The script will now close. (414)"
sleep 3
echo -e "QUITAPP\n"
fi

# Due to the way the output is formatted, we have to strip 10 chars at the start
PKG_LOC=$(echo "${PKG_LOC}" | cut -d : -f 2)

# Now let's kill the running Andromeda services on the mobile device
KILL=$("${ADB_LOC}" shell pidof andromeda)

# Check if we need to kill the existing pids, then kill them if need be
if [[ "$KILL" == "" ]]
then
echo
"${ADB_LOC}" shell << EOF
am force-stop projekt.substratum
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH="${PKG_LOC}" app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
echo "You can now remove your device from the computer!"
echo " "
echo "The script will now close. (0)"
sleep 2
echo "QUITAPP\n"
exit
EOF
else
echo
"${ADB_LOC}" shell << EOF
am force-stop projekt.substratum
kill -9 "${KILL}"
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH="${PKG_LOC}" app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
echo "You can now remove your device from the computer!"
echo " "
echo "The script will now close. (0)"
sleep 2
echo "QUITAPP\n"
exit
EOF
fi