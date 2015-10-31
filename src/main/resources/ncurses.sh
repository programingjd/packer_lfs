#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/ncurses-*.tar.* --directory $BUILD
cd $BUILD/ncurses-*

sed -i s/mawk// configure

mkdir -v ../tmp
cd ../tmp

../ncurses-*/configure \
  --prefix=/tools \
  --with-shared \
  --without-debug \
  --without-ada \
  --enable-widec \
  --enable-overwrite

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
