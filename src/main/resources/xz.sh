#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/xz-*.tar.* --directory $BUILD
cd $BUILD/xz-*

mkdir -v ../tmp
cd ../tmp

../xz-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
