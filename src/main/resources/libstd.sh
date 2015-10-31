#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/gcc-*.tar.* --directory $BUILD
ln -s $BUILD/gcc-* $BUILD/gcc

cd $BUILD/gcc-*

VERSION=${PWD##*gcc-}

mkdir -v ../tmp
cd ../tmp

../gcc-*/libstdc++-*/configure \
  --prefix=/tools \
  --host=$LFS_TGT \
  --disable-nls \
  --disable-multilib \
  --disable-libstdcxx-threads \
  --disable-libstdcxx-pch \
  --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$VERSION

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
