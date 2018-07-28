#!/bin/sh

andromeda=$(pm path projekt.andromeda)

# Let's first grab the location where Andromeda is installed
pkg=$andromeda

# Due to the way the output is formatted, we have to strip 10 chars at the start
pkg=$(echo "$pkg" | cut -d : -f 2 | sed s/\\r//g)

export CLASSPATH=$pkg
nohup app_process /system/bin --nice-name=andromeda projekt.andromeda.Andromeda >/dev/null 2>&1 &