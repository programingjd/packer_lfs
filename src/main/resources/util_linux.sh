#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/util-linux-*.tar.* --directory $BUILD
cd $BUILD/util-linux-*

mkdir -v ../tmp
cd ../tmp

../util-linux-*/configure \
  --prefix=/tools \
  --without-python \
  --disable-makeinstall-chown \
  --without-systemdsystemunitdir \
  PKG_CONFIG=""

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
