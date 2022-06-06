#!/bin/sh
FILE=~/.config/i3status/config

sed -i "s,\/<user_home>,$HOME,g" $FILE
