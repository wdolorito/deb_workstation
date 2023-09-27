#!/bin/sh

export CC=clang
export LDFLAGS=-fuse-ld=lld
BUILDDIR="$HOME"/.local/suckless
TOPLEVEL="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
if ! [ -d "$BUILDDIR" ]
then
  mkdir -p "$BUILDDIR"
fi

# clone and build suckless tools

clone_and_build() {
  cd "$BUILDDIR" || exit
  git clone "$URL" "$DIR"
  mkdir "$DIR"
  rm -f "$BUILDDIR/$DIR/config.h"
  rm -f "$BUILDDIR/$DIR/config.mk"
  cd "$DIR" || exit
  cp -v "$TOPLEVEL/suckless-conf/$CONFIG" "$BUILDDIR/$DIR/config.h"
  cp -v "$TOPLEVEL/suckless-conf/$MKCONFIG" "$BUILDDIR/$DIR/config.mk"
  make clean install
}

# dwm
DIR="dwm"
CONFIG="dwm-config.h"
MKCONFIG="dwm-config.mk"
URL="https://git.sr.ht/~bt/dwm"
clone_and_build

# dmenu
DIR="dmenu"
CONFIG="dmenu-config.h"
MKCONFIG="dmenu-config.mk"
URL="https://git.sr.ht/~bt/dmenu"
clone_and_build

# slstatus
DIR="slstatus"
CONFIG="slstatus-config.h"
MKCONFIG="slstatus-config.mk"
URL="https://git.sr.ht/~bt/slstatus"
clone_and_build


DIR="st"
CONFIG="st-config.h"
MKCONFIG="st-config.mk"
URL="https://git.sr.ht/~bt/st"
clone_and_build
