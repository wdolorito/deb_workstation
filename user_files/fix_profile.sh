#!/bin/sh
FILE=~/.profile

echo "" >> "$FILE"
echo "# set PATH so it includes user's private bin if it exists" >> "$FILE"
echo 'if [ -d "$HOME/local/bin" ]' >> "$FILE"
echo "then" >> "$FILE"
echo '  PATH="$HOME/local/bin:$PATH"' >> "$FILE"
echo "fi" >> "$FILE"
echo "" >> "$FILE"
echo 'export $(gnome-keyring-daemon -s)' >> "$FILE"
echo "# needed for lxc" >> "$FILE"
echo "export DOWNLOAD_KEYSERVER=keyserver.ubuntu.com" >> "$FILE"
echo "export GTK_THEME=Adwaita:dark" >> "$FILE"
echo "export NEXT_TELEMETRY_DISABLED=1" >> "$FILE"
echo "" >> "$FILE"
echo 'if ! [ "$TERM" = "screen" ]' >> "$FILE"
echo "then" >> "$FILE"
echo "  start_tmux" >> "$FILE"
echo "fi" >> "$FILE"
# for runit-init
#echo "export SVDIR=$HOME/local/runit-services" >> $FILE
#echo "SV=`pgrep -u $(whoami) rusvdir`" >> $FILE
#echo 'if [ -z "$SV" ]' >> $FILE
#echo "then" >> $FILE
#echo '  runsvdir -P $SVDIR &' >> $FILE
#echo 'fi' >> $FILE
