#!/bin/sh
FILE=~/.config/transmission/settings.json

mkdir -p ~/Downloads/Incoming

sed -i "s,\/home\/<user>,$HOME,g" $FILE
