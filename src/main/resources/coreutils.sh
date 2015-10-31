#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/coreutils-*.tar.* --directory $BUILD
cd $BUILD/coreutils-*

mkdir -v ../tmp
cd ../tmp

../coreutils-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
