#!/bin/bash

CL_RST="\033[0m"
CL_YLW="\033[01;33m"
CL_BLUE="\033[01;34m"
VERSION="$(git describe --tags)"

# Some housekeeping never hurt anybody
git clean -fdx >/dev/null 2>&1

echo -e "${CL_BLUE}Version: ${VERSION}${CL_RST}"
for platform in Linux macOS; do
    echo -e "${CL_YLW}Packaging for ${platform}...${CL_RST}"
    tar -cf andromeda_scripts_"${VERSION}"_"${platform}".tar "${platform}/"
done

for platform in Windows Android; do
    echo -e "${CL_YLW}Packaging for ${platform}...${CL_RST}"
    zip -r andromeda_scripts_"${VERSION}"_"${platform}".zip "${platform}/" >/dev/null 2>&1
done