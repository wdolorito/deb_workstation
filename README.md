# dotfiles and notes for Debian stable sway installation

* install packages in packages
* read notes in packages for additional user/superuser commands to run after package installation
* flatpaks
```
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak --user remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

for app in $(cat flatpak_apps.txt) ; do flatpak install flathub -y --noninteractive "$app" ; done

flatpak --user override --env="FLATPAK_ENABLE_SDK_EXT=llvm20,node24,openjdk21" com.vscodium.codium
```
* patch bash + profile dots
```
cd "$HOME"

for patch in <path to repo>/user_files/*.patch ; do patch < "$patch" ; done
```
