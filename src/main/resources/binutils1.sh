#!/bin/bash

sudo apt-get -q -y install gcc
sudo apt-get -q -y install make

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/binutils-*.tar.* --directory $BUILD
cd $BUILD/binutils-*

mkdir -v ../tmp
cd ../tmp

../binutils-*/configure \
  --prefix=/tools \
  --target=$LFS_TGT \
  --with-sysroot=$LFS \
  --with-lib-path=/tools/lib \
  --disable-nls \
  --disable-werror

make -j16

case $(uname -m) in
  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac

make install

cd $BUILD

rm -rf $BUILD/*
