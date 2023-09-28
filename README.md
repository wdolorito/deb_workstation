# dotfiles and notes for Debian/Devuan stable sway/i3 workstation (laptop centric) installation
## bonus: compile suckless from source to local home installation xorg notes

### File listing:
```
.
├── README.md
├── common.txt
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
│   │   ├── picom
│   │   │   └── picom.conf
│   │   ├── sakura
│   │   │   └── sakura.conf
│   │   ├── sway
│   │   │   └── config
│   │   ├── transmission
│   │   │   └── settings.json
│   │   └── waybar
│   │       ├── config
│   │       └── style.css
│   ├── .fbtermrc
│   ├── .fonts
│   │   ├── Font Awesome 6 Brands-Regular-400.otf
│   │   ├── Font Awesome 6 Free-Regular-400.otf
│   │   ├── Font Awesome 6 Free-Solid-900.otf
│   │   └── Inconsolata-VariableFont_wdth,wght.ttf
│   ├── .gitconfig
│   ├── .ssh
│   │   └── config
│   ├── .tmux.conf
│   ├── fix_i3status.sh
│   ├── fix_profile.sh
│   ├── fix_trans.sh
│   ├── install_node_local.sh
│   └── local
│       ├── AppImage
│       │   └── GIMP_AppImage-git-2.99.3-20201112-x86_64.AppImage
│       ├── bin
│       │   ├── bright
│       │   ├── bright_key
│       │   ├── chromium
│       │   ├── codium
│       │   ├── deb_hib
│       │   ├── deb_sus
│       │   ├── dev_hib
│       │   ├── dev_sus
│       │   ├── dhclient
│       │   ├── dmesg
│       │   ├── gimp
│       │   ├── google-chrome
│       │   ├── imv
│       │   ├── lock_msg
│       │   ├── lock_screen
│       │   ├── pchromium
│       │   ├── pfirefox
│       │   ├── pgoogle-chrome
│       │   ├── reboot
│       │   ├── shutdown
│       │   ├── start_dwm
│       │   ├── start_home
│       │   ├── start_i3
│       │   ├── start_tmux
│       │   ├── sway
│       │   ├── vol
│       │   └── wpa_supplicant
│       ├── runit-services
│       │   └── service
│       │       └── run
│       └── wireless
│           └── network
├── wayland
│   ├── fix_wdisplays.sh
│   └── setup.txt
└── xorg
    ├── .xinitrc
    ├── 30-touchpad.conf
    ├── compile_suckless.sh
    ├── setup.txt
    └── suckless-conf
        ├── dmenu-config.h
        ├── dmenu-config.mk
        ├── dwm-config.h
        ├── dwm-config.mk
        ├── slstatus-config.h
        ├── slstatus-config.mk
        ├── st-config.h
        └── st-config.mk
```

`wayland` has scripts and a file with packages to install for sway/wayland.  `xorg` has a touchpad configuration file and a file with packages to install for i3/xorg.  Both window managers may be used side by side with these supporting configuration files if installed at the same time.  `common.txt` are programs chosen that have wayland and xorg compatibility.  Noted exception is kicad.

For a pure wayland environment, do not install that program and use gimp v2.99.2+, which is not included in Debian 11 nor Devuan 4 repos.  The placeholder in `user_files` is the file name from the AppImage releases of gimp.  `fix_wdisplays.sh` should be run as root whenever that program is updated to restore the icon in wofi/rofi.  If switching between sway and i3; avoid running `google-chrome`, `chromium` or `codium` from their respective `.desktop` files via wofi as they will launch in xwayland.

Copy all files from `user_files` in to user directory as user.  Alternately, copy as root, then `chown -R <user>:<user>` all files.  As user, run `fix_*.sh` scripts from `user_files`.  They may be deleted afterwards.

All files from `root_files` can be copied to `/root` for convenience.  `createswap` will create a `swapfile` at the root of the filesystem and modify `/etc/fstab`.  Modify `doas.conf` for user(s) and copy to `/etc`. Run `fix_pam.sh` to allow `gnome-keyring` to be used on login for users.  `findswap` will print a line useable for `/etc/default/grub` to enable hibernation. `set_default_browser` to fix `sensible-browser` links (will set firefox-esr).

The `samsung_chromebook` folder has files specific to the first gen [Samsung Arm Chromebook, model XE303C12](https://www.samsung.com/us/business/support/owners/product/chromebook-xe303c12/).  i3/xorg is used over sway/wayland for max compatiblity.  `armhf` binaries for `codium` and `nodejs` development are still available, however c/c++ development is not easily available because development headers are unable to be installed..

The second half of setup.txt in xorg should be installed for a [suckless](https://tools.suckless.org/) local installation.  Install the packages with apt, then run `compile_suckless.sh` as user.  This script will clone the dwm, slstatus, dmenu and st repos in to `$HOME/.local/suckless`, compile these projects using clang using the configuration files in `suckless-conf` and install each binary in to `$HOME/local`.  Be sure to copy `.xinitrc-suckless` to the user directory and launch dwm with `start_dwm`.

The mod key is `Alt` for dwm.  Some important shortcuts to start with are `Alt+Shift+Enter` to start st (terminal program), `Alt-Shift-o` to launch Firefox, `Alt-p` to start dmenu (status bar changes to program launcher, start typing to get a list of launchable programs e.g. codium) and finally `Alt-Shift-q` to exit.  Look at `xorg/suckless-conf/dwm-config.h` for other keyboard shortcut combinations.  Modify `$HOME/.local/suckless/dwm/config.h` and recompile (`make clean install`) to add/change keyboard shortcuts.  The same is true for the other suckless programs.  slstatus should be modified if default wifi interface is not `wlp2s0` or to monitor a different battery than `BAT0` and is necessary to modify to read `.bright` in the user home directory.  st should be modified if a different font is preferred over Inconsolata.  dmenu font is set in dwm's `config.h` (default is Liberation Mono in the included config files).
