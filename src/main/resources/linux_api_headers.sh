#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/linux-*.tar.* --directory $BUILD
cd $BUILD/linux-*

make mrproper

make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include

cd $BUILD

rm -rf $BUILD/*
