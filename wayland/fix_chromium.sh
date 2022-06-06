#!/bin/sh
FILE=/usr/share/applications/chromium.desktop

sed -i "s/chromium\ /chromium\ --enable-features=UseOzonePlatform\ --ozone-platform=wayland\ /g" $FILE
