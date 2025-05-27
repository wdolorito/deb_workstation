# start status bar
slstatus &

# set wallpaper
# feh --bg-fill ~/Pictures/<background>.png

# compositor
picom --vsync &

# screen locker
xset s 300
xss-lock --transfer-sleep-lock -- physlock -dmsp "$LOCK_MSG" &

exec dbus-run-session dwm > ~/.dwm.log
