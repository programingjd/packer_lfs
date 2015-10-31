#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/gettext-*.tar.* --directory $BUILD
cd $BUILD/gettext-*

mkdir -v ../tmp
cd ../tmp

EMACS="no" \
../gettext-*/gettext-tools/configure \
  --prefix=/tools \
  --disable-shared

make -j16 -C gnulib-lib
make -j16 -C intl pluralx.c
make -j16 -C src msgfmt
make -j16 -C src msgmerge
make -j16 -C src xgettext

cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin

cd $BUILD

rm -rf $BUILD/*
