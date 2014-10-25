#!/usr/bin/env bash

set -e

REPO=retroarch-assets
PRGNAM=libretro-assets
TMP=${TMP:-/tmp}
PKG=$TMP/package-$REPO
BUILD=1

rm -rf $PKG
rm -rf $TMP/$REPO

mkdir -p $PKG
cd $TMP
git clone https://github.com/libretro/${REPO}.git
cd $REPO

chown -R root:root .
find -L . \
 \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
  -o -perm 511 \) -exec chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

CWD=`pwd`
VERSION=`git rev-parse --short HEAD`

mkdir -p $PKG/usr/share/libretro/assets
find . -type d  -maxdepth 1 -not -name ".*" -exec cp -r {} $PKG/usr/share/libretro/assets \;
find $PKG/usr/share/libretro/assets -type d -name src -prune -exec rm -r {} \;

cd $PKG
/sbin/makepkg -l y -c n $TMP/$PRGNAM-$VERSION-noarch-${BUILD}.txz
