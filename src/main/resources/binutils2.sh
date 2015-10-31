#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/binutils-*.tar.* --directory $BUILD
cd $BUILD/binutils-*

mkdir -v ../tmp
cd ../tmp

CC=$LFS_TGT-gcc \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../binutils-*/configure \
  --prefix=/tools \
  --with-sysroot \
  --with-lib-path=/tools/lib \
  --disable-nls \
  --disable-werror

make -j16

make install

make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

cd $BUILD

rm -rf $BUILD/*
