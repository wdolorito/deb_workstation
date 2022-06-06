#!/bin/sh
FILE=/usr/share/applications/network.cycles.wdisplays.desktop

sed -i "s/Icon=network.cycles.wdisplays/Icon=wdisplays/g" $FILE
