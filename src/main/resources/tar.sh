#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/tar-*.tar.* --directory $BUILD
cd $BUILD/tar-*

mkdir -v ../tmp
cd ../tmp

../tar-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
