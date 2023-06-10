#!/bin/sh
VERSIONS="10.x/ 12.x/ 14.x/ 16.x/ 18.x/"
LTS="18"
BASELINK="https://nodejs.org/dist/latest-v"
OSTYPE=$(uname | tr '[:upper:]' '[:lower:]')
MACHTYPE=$(uname -m)
TOGET=
ARCHIVEDIR="$HOME/local/archive"
UNPACKDIR="$HOME/local/node"
LOCALBINDIR="$HOME/local/bin"
GETTER="curl"
LISTOPTIONS="-s"
DOWNLOADOPTIONS="-O"
ALIASFILE="$HOME/.bash_aliases"
NODEBINS="corepack node npm npx"

if [ "$MACHTYPE" = "x86_64" ]
then
  MACHTYPE="x64"
fi

display_usage() {
  printf "\n\tusage:\t\t%s <option>\n\n" "$0"
  printf "\tWhere <option> is one of the following:\n\n"
  printf "\tinstall\t- download and install node versions %s\n" "$(echo "$VERSIONS" | sed 's/\.x\///g')(LTS)"
  printf "\t\t  will also add aliases to %s\n" "$ALIASFILE"
  printf "\tremove\t- remove all node versions and downloaded archives\n"
  printf "\t\t  and remove aliases from %s\n" "$ALIASFILE"
  printf "\tupgrade\t- remove all LTS versions and download and install current LTS\n"
  printf "\t\t  and update LTS aliases in %s\n\n" "$ALIASFILE"
  printf "\tDownloaded node archives will be stored in\n\t\t%s\n\n" "$ARCHIVEDIR"
  printf "\tNode archives will be unpacked to\n\t\t%s\n\n" "$UNPACKDIR"
}

check_paths() {
  if ! [ -f "$ALIASFILE" ]
  then
    touch "$ALIASFILE"
  fi

  if ! [ -d "$ARCHIVEDIR" ]
  then
    mkdir -p "$ARCHIVEDIR"
  fi

  if ! [ -d "$UNPACKDIR" ]
  then
    mkdir -p "$UNPACKDIR"
  fi

  if ! [ -d "$LOCALBINDIR" ]
  then
    mkdir -p "$LOCALBINDIR"
  fi
}

link_lts() {
  if [ "$1" = "$LTS" ]
  then
    for BINARY in "$2"/bin/*
    do
      ln -sf "$BINARY" "$LOCALBINDIR"
    done
  fi
}

mod_aliases() {
  NODEVER=$(echo "$1" | cut -dv -f2 | cut -d. -f1)
  for BINARY in "$1"/bin/*
  do
    BASEDBIN=$(basename "$BINARY")
    echo "alias $BASEDBIN$NODEVER=\"PATH=$1/bin:\$PATH $BASEDBIN\"" >> "$ALIASFILE"
  done
  link_lts "$NODEVER" "$1"
}

unpack_file() {
  if ! [ -d "$UNPACKDIR" ]
  then
    mkdir -p "$UNPACKDIR"
  fi

  DIRNAME=$(echo "$1" | cut -d. -f1-3)

  if [ -d "$UNPACKDIR"/"$DIRNAME" ]
  then
    rm -rf "${UNPACKDIR:?}"/"$DIRNAME"
  fi

  tar xf "$1" -C "$UNPACKDIR"
  mod_aliases "$UNPACKDIR"/"$DIRNAME"
}

get_file() {
  if [ ! "$(pwd)" = "$ARCHIVEDIR" ]
  then
    cd "$ARCHIVEDIR" || exit
  fi
  if [ ! -f "$ARCHIVEDIR"/"$2" ]
  then
    $GETTER $DOWNLOADOPTIONS "$1""$2"
    unpack_file "$2"
  else
    echo "$2 already exists"
  fi

  cd "$CWD" || exit
}

parse_list() {
  TOGET=$($GETTER $LISTOPTIONS "$1" | grep node | awk '{print $2}' | cut -d \" -f 2 | grep xz | grep "$OSTYPE" | grep "$MACHTYPE")
  get_file "$1" "$TOGET"
  cd "$ARCHIVEDIR" || exit
  CWD=$(pwd)
}

start_it() {
  if [ ! -d "$ARCHIVEDIR" ]
  then
    mkdir -p "$ARCHIVEDIR"
  fi

  for VERSION in $VERSIONS
  do
    parse_list "$BASELINK$VERSION"
  done
}

remove_all() {
  for NODEBIN in $NODEBINS
  do
    sed -i "/$NODEBIN/Id" "$ALIASFILE"
    rm -rf "${LOCALBINDIR:?}"/"$NODEBIN"
  done
  for ARCHIVE in "$ARCHIVEDIR"/node-v*xz
  do
    rm -rf "$ARCHIVE"
  done
  rm -rf "$UNPACKDIR"
}

remove_lts() {
  for NODEBIN in $NODEBINS
  do
    rm -rf "${LOCALBINDIR:?}"/"$NODEBIN"
    sed -i "/$NODEBIN$LTS/Id" "$ALIASFILE"
  done
  rm -rf "$ARCHIVEDIR"/node-v"$LTS"*xz
  rm -rf "$UNPACKDIR"/node-v"$LTS"*
}

if ! which curl > /dev/null
then
  if ! which wget > /dev/null
  then
    echo "Please install curl or wget"
    exit 1
  else
    GETTER="wget"
    LISTOPTIONS="-q -O -"
    DOWNLOADOPTIONS=" -- "
  fi
fi

case "$1" in
  "install")
    check_paths
    start_it
    ;;
  "remove")
    remove_all
    ;;
  "upgrade")
    check_paths
    remove_lts
    parse_list "$BASELINK$LTS.x/"
    ;;
  *)
    display_usage
    ;;
esac
