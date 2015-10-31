#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/texinfo-*.tar.* --directory $BUILD
cd $BUILD/texinfo-*

mkdir -v ../tmp
cd ../tmp

../texinfo-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
