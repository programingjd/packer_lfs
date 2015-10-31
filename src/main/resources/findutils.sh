#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/findutils-*.tar.* --directory $BUILD
cd $BUILD/findutils-*

mkdir -v ../tmp
cd ../tmp

../findutils-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
