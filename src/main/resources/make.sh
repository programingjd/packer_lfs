#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/make-*.tar.* --directory $BUILD
cd $BUILD/make-*

mkdir -v ../tmp
cd ../tmp

../make-*/configure \
  --prefix=/tools \
  --without-guile

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
