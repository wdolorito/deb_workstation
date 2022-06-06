# dotfiles and notes for Debian/Devuan stable sway/i3 workstation (laptop centric) installation

## File listing:
```
.
├── common.txt
├── README.md
├── root_files
│   ├── createswap
│   ├── doas.conf
│   ├── findswap
│   ├── fix_pam.sh
│   ├── install_codium.sh
│   ├── set_default_browser
│   └── update.sh
├── samsung_chromebook
│   ├── calc_bat
│   ├── createswap
│   ├── dev_sus
│   ├── doas.conf
│   ├── exit_i3
│   ├── i3
│   │   └── config
│   ├── i3status
│   │   └── config
│   ├── reboot
│   ├── setup.txt
│   └── shutdown
├── user_files
│   ├── .bash_aliases
│   ├── .config
│   │   ├── dunst
│   │   │   └── dunstrc
│   │   ├── i3
│   │   │   └── config
│   │   ├── i3status
│   │   │   └── config
│   │   ├── lxc
│   │   │   └── default.conf
│   │   ├── sakura
│   │   │   └── sakura.conf
│   │   ├── sway
│   │   │   └── config
│   │   ├── transmission
│   │   │   └── settings.json
│   │   └── waybar
│   │       ├── config
│   │       └── style.css
│   ├── fix_i3status.sh
│   ├── fix_profile.sh
│   ├── fix_trans.sh
│   ├── .fonts
│   │   ├── Font Awesome 6 Brands-Regular-400.otf
│   │   ├── Font Awesome 6 Free-Regular-400.otf
│   │   ├── Font Awesome 6 Free-Solid-900.otf
│   │   └── Inconsolata-VariableFont_wdth,wght.ttf
│   ├── .gitconfig
│   ├── local
│   │   ├── AppImage
│   │   │   └── GIMP_AppImage-git-2.99.3-20201112-x86_64.AppImage
│   │   ├── bin
│   │   │   ├── bright
│   │   │   ├── bright_key
│   │   │   ├── chromium
│   │   │   ├── codium
│   │   │   ├── deb_hib
│   │   │   ├── deb_sus
│   │   │   ├── dhclient
│   │   │   ├── dmesg
│   │   │   ├── exit_i3
│   │   │   ├── gimp -> ../AppImage/GIMP_AppImage-git-2.99.3-20201112-x86_64.AppImage
│   │   │   ├── google-chrome
│   │   │   ├── imv
│   │   │   ├── pchromium
│   │   │   ├── pfirefox
│   │   │   ├── pgoogle-chrome
│   │   │   ├── reboot
│   │   │   ├── shutdown
│   │   │   ├── start_home
│   │   │   ├── sway
│   │   │   ├── vol
│   │   │   └── wpa_supplicant
│   │   ├── runit-services
│   │   │   └── service
│   │   │       └── run
│   │   └── wireless
│   │       └── network
│   └── .ssh
│       └── config
├── wayland
│   ├── fix_chrome.sh
│   ├── fix_chromium.sh
│   ├── fix_codium.sh
│   ├── fix_wdisplays.sh
│   └── setup.txt
└── xorg
    ├── 30-touchpad.conf
    └── setup.txt
```

`wayland` has scripts and a file with packages to install for sway/wayland.  `xorg` has a touchpad configuration file and a file with packages to install for i3/xorg.  Both window managers may be used side by side with these supporting configuration files if installed at the same time.  `common.txt` are programs chosen that have wayland and xorg compatibility.  Noted exceptions are libreoffice and kicad.

For a pure wayland environment, do not install those two programs and use gimp v2.99.2+, which is not included in Debian 11 nor Devuan 4 repos.  The placeholder in `user_files` is the file name from the AppImage releases of gimp.  `fix_chrome.sh`, `fix_chromium` and `fix_codium.sh` should be run as root whenever those two programs are updated.  If switching between sway and i3; avoid running `google-chrome`, `chromium` or `codium` from their respective `.desktop` files via wofi/rofi.

Copy all files from `user_files` in to user directory as user.  Alternately, copy as root, then `chown -R <user>:<user>` all files.  As user, run `fix_*.sh` scripts from `user_files`.  They may be deleted afterwards.

All files from `root_files` can be copied to `/root` for convenience.  `createswap` will create a `swapfile` at the root of the filesystem and modify `/etc/fstab`.  Modify `doas.conf` for user(s) and copy to `/etc`. `fix_pam.sh` to allow `gnome-keyring` to be used on login for users.  `findswap` will print a line useable for `/etc/default/grub` as well as `/etc/initramfs-tools/conf.d/resume` to enable hibernation. `set_default_browser` to fix `sensible-browser` links.

The `samsung_chromebook` folder has files specific to the first gen [Samsung Arm Chromebook, model XE303C12](https://www.samsung.com/us/business/support/owners/product/chromebook-xe303c12/).  i3/xorg is used over sway/wayland for max compatiblity.  `armhf` binaries for `codium` and `nodejs` development are still available, however c/c++ development is not easily available because development headers are unable to be installed.