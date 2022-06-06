#!/bin/sh
FILE=/usr/share/applications/google-chrome.desktop

sed -i "s/google-chrome-stable/google-chrome-stable\ --enable-features=UseOzonePlatform\ --ozone-platform=wayland/g" $FILE
