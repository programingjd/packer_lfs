#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/gzip-*.tar.* --directory $BUILD
cd $BUILD/gzip-*

mkdir -v ../tmp
cd ../tmp

../gzip-*/configure \
  --prefix=/tools

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
