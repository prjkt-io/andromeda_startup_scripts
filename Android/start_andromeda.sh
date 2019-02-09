#!/system/bin/sh

if [ "$(whoami)" != "root" ]; then
    printf "This script needs to be executed as root!\n"
    exit 1
fi

echo "Andromeda Start Shell Script by [projekt.] development team"
echo ""
echo "This requires projekt.andromeda to be installed on the device"
echo "Make sure the device is connected and ADB option enabled"
echo "Please only have one device connected at a time to use this!"
echo ""

# Let's first grab the location where Andromeda is installed
pkg=$(pm path projekt.andromeda | sed 's/package://')

# Now let's kill the running Andromeda services on the mobile device
kill=$(pidof andromeda)

# Check if we need to kill the existing pids, then kill them if need be
if [ "${kill}" = "" ]; then
echo << EOF
am force-stop projekt.substratum
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH="${pkg}" app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
exit
EOF
else
echo << EOF
am force-stop projekt.substratum
kill -9 "${kill}"
appops set projekt.andromeda RUN_IN_BACKGROUND allow
appops set projekt.substratum RUN_IN_BACKGROUND allow
CLASSPATH="${pkg}" app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda &
exit
EOF
fi
