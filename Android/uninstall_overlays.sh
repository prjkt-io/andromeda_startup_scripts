#!/system/bin/sh

if [ "$(whoami)" != "root" ]; then
    printf "This script needs to be executed as root!\n"
    exit 1
fi

printf "Uninstalling disabled overlays\n"
for item in $(cmd overlay list | grep '\[ \]' | sed 's/\[ \]//');do echo "${item}" && pm uninstall "${item}";done

printf "Uninstalling enabled overlays\n"
for item in $(cmd overlay list | grep '\[x\]' | sed 's/\[x\]//');do echo "${item}" && pm uninstall "${item}";done

printf "Uninstalling pink state overlays\n"
for item in $(cmd overlay list | grep '\-\-\-' | sed 's/--- //');do echo "${item}" && pm uninstall "${item}";done
