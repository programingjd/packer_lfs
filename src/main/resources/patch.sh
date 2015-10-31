#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/patch-*.tar.* --directory $BUILD
cd $BUILD/patch-*

mkdir -v ../tmp
cd ../tmp

../patch-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
