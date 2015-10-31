#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/sed-*.tar.* --directory $BUILD
cd $BUILD/sed-*

mkdir -v ../tmp
cd ../tmp

../sed-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
