#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/bash-*.tar.* --directory $BUILD
cd $BUILD/bash-*

mkdir -v ../tmp
cd ../tmp

../bash-*/configure \
  --prefix=/tools \
  --without-bash-malloc

make -j16

make install

ln -sv bash /tools/bin/sh

cd $BUILD

rm -rf $BUILD/*
