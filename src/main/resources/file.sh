#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/file-*.tar.* --directory $BUILD
cd $BUILD/file-*

mkdir -v ../tmp
cd ../tmp

../file-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
