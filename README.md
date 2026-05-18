# dotfiles and notes for Debian sway + wayfire installation

### install packages
**as root**
 ```
 cd <path to repo>
 cp root_files/debian.sources /etc/apt/sources.d
 apt update
 apt dist-upgrade
 grep -v -E "#|apt|dpkg|^$" packages | xargs apt install -y
 apt autoremove --purge
 cp root_files/doas.conf /etc
 chmod 600 /etc/doas.conf
 usermod -aG "$(cat root_files/usergroups.txt)" <new user>
 ```

### copy user files
**as ```<new user>```**
```
cd "$HOME"
cp -r <path to repo>/user_files/local .
cd <path to repo>/user_files/dots
cp -r .config .ssh .bash_aliases .fbtermrc .gitconfig ~/
```
* edit ~/.gitconfig and replace ```<your name>``` and ```<your email>```
* edit ~/.config/waybar/config-* and replace interface name in network section
* edit ~/.config/waybar/config-* and replace device name in backlight section
* ```<path to repo>/user_files/bookmarks-debian.json``` can be imported directly in to floorp/firefox browsers
* ```<path to repo>/user_files/bookmarks-debian.html``` can be used to import bookmarks to other browsers

### install flatpaks
```
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak --user remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

cd <path to repo>
for app in $(cat flatpak_apps.txt) ; do flatpak install flathub -y --noninteractive "$app" ; done

# install codium extensions
for extension in $(cat user_files/codium_extensions) ; do codium --install-extension "$extension" ; done
```

### patch shell rcs + profile dots
```
cd "$HOME"
cp /etc/skel/.mkshrc .
chsh -s /bin/mksh

for patch in <path to repo>/user_files/*.patch ; do patch < "$patch" ; done
```

### dark mode
```
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```
