#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/grep-*.tar.* --directory $BUILD
cd $BUILD/grep-*

mkdir -v ../tmp
cd ../tmp

../grep-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
