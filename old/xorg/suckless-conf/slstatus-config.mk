# slstatus version
VERSION = 0

# customize below to fit your system

# paths
PREFIX = ${HOME}/local
MANPREFIX = $(PREFIX)/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# flags
CPPFLAGS = -I$(X11INC) -D_DEFAULT_SOURCE
CFLAGS   = -std=c99 -pedantic -Wall -Wextra -Wno-unused-parameter -Os
LDFLAGS  = -L$(X11LIB) -s -fuse-ld=lld
# OpenBSD: add -lsndio
# FreeBSD: add -lkvm -lsndio
LDLIBS   = -lX11

# compiler and linker
CC = clang
