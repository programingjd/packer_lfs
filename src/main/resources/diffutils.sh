#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/diffutils-*.tar.* --directory $BUILD
cd $BUILD/diffutils-*

mkdir -v ../tmp
cd ../tmp

../diffutils-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
