#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/bzip2-*.tar.* --directory $BUILD
cd $BUILD/bzip2-*

mkdir -v ../tmp
cd ../tmp

../bzip2-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
