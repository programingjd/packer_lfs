#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/glibc-*.tar.* --directory $BUILD
ln -s $BUILD/glibc-* $BUILD/glibc

cd $BUILD/glibc-*
cp $SOURCES/glibc-*_i386_fix*.patch ./glibc-patch1.patch
patch -Np1 -i glibc-patch1.patch

mkdir -v ../tmp
cd ../tmp

../glibc-*/configure \
  --prefix=/tools \
  --host=$LFS_TGT \
  --build=$(../glibc/scripts/config.guess) \
  --disable-profile \
  --enable-kernel=2.6.32 \
  --enable-obsolete-rpc \
  --with-headers=/tools/include \
  libc_cv_forced_unwind=yes \
  libc_cv_ctors_header=yes \
  libc_cv_c_cleanup=yes

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
