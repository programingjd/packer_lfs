#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/gawk-*.tar.* --directory $BUILD
cd $BUILD/gawk-*

mkdir -v ../tmp
cd ../tmp

../gawk-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
