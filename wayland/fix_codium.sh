#!/bin/sh
MFILE=/usr/share/applications/codium.desktop
SFILE=/usr/share/applications/codium-url-handler.desktop

chmod -x $MFILE
sed -i "s/codium\ --/codium\ --enable-features=UseOzonePlatform\ --ozone-platform=wayland\ --/g" $MFILE
sed -i "s/codium\ --/codium\ --enable-features=UseOzonePlatform\ --ozone-platform=wayland\ --/g" $SFILE
