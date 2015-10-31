#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/m4-*.tar.* --directory $BUILD
cd $BUILD/m4-*

mkdir -v ../tmp
cd ../tmp

../m4-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
