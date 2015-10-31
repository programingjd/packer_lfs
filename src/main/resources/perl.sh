#!/bin/bash

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/perl-*.tar.* --directory $BUILD
cd $BUILD/perl-*

VERSION=${PWD##*perl-}

sh Configure -des -Dprefix=/tools -Dlibs=-lm

make -j16

cp -v perl cpan/podlators/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/$VERSION
cp -Rv lib/* /tools/lib/perl5/$VERSION

cd $BUILD

rm -rf $BUILD/*
