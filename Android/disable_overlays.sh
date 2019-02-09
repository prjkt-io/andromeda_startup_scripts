#!/system/bin/sh

if [ "$(whoami)" != "root" ]; then
    printf "This script needs to be executed as root!\n"
    exit 1
fi

echo "Overlay Disabler Shell Script by [projekt.] development team"
echo ""
echo "Make sure the device is connected and ADB option enabled"
echo "Please only have one device connected at a time to use this!"
echo ""

printf "\nDisabling overlays\n"
for item in $(cmd overlay list | grep '\[x\]' | sed 's/\[x\]//');do cmd overlay disable "${item}";done
