#!/bin/bash

CL_RST="\033[0m"
CL_YLW="\033[01;33m"

# Some housekeeping never hurt anybody
git clean -fdx

for platform in Linux macOS; do
    echo -e "${CL_YLW}Packaging for ${platform}...${CL_RST}"
    tar -cf andromeda_scripts_"$(git describe --tags)"_"${platform}".tar "${platform}/"
done

for platform in Windows; do
    echo -e "${CL_YLW}Packaging for ${platform}...${CL_RST}"
    zip -r andromeda_scripts_"$(git describe --tags)"_"${platform}".zip "${platform}/" >/dev/null 2>&1
done