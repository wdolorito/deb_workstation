#!/bin/sh
GETTER=""
LISTOPTIONS=""
DOWNLOADOPTIONS=""
CURL="$(curl --version 2>/dev/null)"
WGET="$(wget --version 2>/dev/null)"
BASELINK="https://nodejs.org/dist/"
VERSIONS=""
VERSIONNUMBERS=""
LTS="18"
CURRENT="20"
OSTYPE=$(uname | tr '[:upper:]' '[:lower:]')
MACHTYPE=$(uname -m)
TOGET=""
ARCHIVEDIR="$HOME/local/archive"
UNPACKDIR="$HOME/local/node"
LOCALBINDIR="$HOME/local/bin"
ALIASFILE="$HOME/.bash_aliases"
NODEBINS=""

case "$MACHTYPE" in
  "x86_64")
    MACHTYPE="x64"
    ;;
  "i686")
    MACHTYPE="x86"
    ;;
  "i386")
    MACHTYPE="x86"
    ;;
esac

display_usage() {
  printf "\n\tusage:\t\t%s <option>\n\n" "$0"
  printf "\tWhere <option> is one of the following:\n\n"
  printf "\tinstall <version> - where <version> is one of the following:\n\n"
  printf "\t\t\tLTS: %s\t CURRENT: %s\n" "$LTS" "$CURRENT"
  printf "\t\t  %s\n\n" "$VERSIONNUMBERS"
  printf "\t\t  will also add aliases to %s\n" "$ALIASFILE"
  printf "\tremove\t- remove all node versions, downloaded archives and\n"
  printf "\t\t  remove aliases from %s\n" "$ALIASFILE"
  printf "\tupgrade\t- upgrade/install current LTS version %s\n\n" "$LTS"
  printf "\tDownloaded node archives will be stored in\n\t\t%s\n\n" "$ARCHIVEDIR"
  printf "\tNode archives will be unpacked to\n\t\t%s\n\n" "$UNPACKDIR"
  printf "\tLTS Node binaries will be soft linked in to\n\t\t%s\n\n" "$LOCALBINDIR"
}

set_versions() {
  VERSIONS="$("$GETTER" $LISTOPTIONS "$BASELINK" | awk -F ">" '{ print $2 }' | grep "^latest-v" | awk -F "<" '{ print $1 }')"
  VERSIONNUMBERS="$(echo "$VERSIONS" | awk -F "-v" '{ print $2 }' | tr -d '/\r\n' | sed 's/\.x/\ /g')"
}

set_getter() {
  if [ -n "$WGET" ]
  then
    GETTER="wget"
      LISTOPTIONS="-q -O -"
      DOWNLOADOPTIONS=" -- "
  fi

  if [ -n "$CURL" ]
  then
    GETTER="curl"
    LISTOPTIONS="-sL"
    DOWNLOADOPTIONS="-O"
  fi

  if [ -z "$GETTER" ]
  then
    echo "Please install curl or wget"
    exit 1
  fi

  set_versions
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

  set_getter
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
    printf "Downloading %s\n" "$(echo "$TOGET" | cut -d - -f 2)"
    $GETTER $DOWNLOADOPTIONS "$1""$TOGET"
    unpack_file "$TOGET"
  else
    printf "Latest version %s archive exists.\n" "$TOGET"
    unpack_file "$TOGET"
  fi
}

parse_list() {
  TOGET="$("$GETTER" $LISTOPTIONS "$BASELINK"latest-v"$1".x | grep node | cut -d \" -f 2 | grep xz | grep "$OSTYPE" | grep "$MACHTYPE")"
  if [ -n "$TOGET" ]
  then
    get_file "$BASELINK"latest-v"$1".x/
  else
    printf "%s %s is not supported.\n" "$OSTYPE" "$MACHTYPE"
    exit 1
  fi
}

remove_all() {
  AMT=$(ls  "$UNPACKDIR" | grep -n . | tail -n 1 | cut -d ":" -f 1)
  if [ -z "$AMT" ] && [ "$AMT" -eq 1 ]
  then
    for NODEBIN in $(ls "$UNPACKDIR"/*/bin)
    do
      sed -i "/$NODEBIN/Id" "$ALIASFILE"
      rm -rf "${LOCALBINDIR:?}"/"$NODEBIN"
    done
  else
    for NODEBIN in $(ls "$UNPACKDIR"/*/bin | grep -v ":" | sort | uniq | tail -n +2)
    do
      sed -i "/$NODEBIN/Id" "$ALIASFILE"
      rm -rf "${LOCALBINDIR:?}"/"$NODEBIN"
    done
  fi
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

bad_exit() {
  set_getter
  display_usage
  exit 1
}

parse_options() {
  case "$1" in
    "install")
      if [ -n "$2" ]
      then
        check_paths
        parse_list "$2"
      else
        bad_exit
      fi
      ;;
    "remove")
      remove_all
      ;;
    "upgrade")
      check_paths
      remove_lts
      parse_list "$LTS"
      ;;
    *)
      bad_exit
      ;;
  esac
}

if [ "$SHELL" = "/bin/bash" ]
then
  parse_options "$@"
else
  echo "This script is meant to be used with bash as a primary shell."
  echo ""
fi
