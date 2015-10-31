#!/bin/bash

sudo apt-get -q -y install g++
#sudo apt-get -q -y install texinfo

SOURCES=$LFS/sources
BUILD=$LFS/build

tar xf $SOURCES/gcc-*.tar.* --directory $BUILD
ln -s $BUILD/gcc-* $BUILD/gcc

tar xf $SOURCES/mpfr-*.tar.* --directory $BUILD
mv -v $BUILD/mpfr-* $BUILD/gcc/mpfr
tar xf $SOURCES/gmp-*.tar.* --directory $BUILD
mv -v $BUILD/gmp-* $BUILD/gcc/gmp
tar xf $SOURCES/mpc-*.tar.* --directory $BUILD
mv -v $BUILD/mpc-* $BUILD/gcc/mpc

cd $BUILD/gcc-*

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

mkdir -v ../tmp
cd ../tmp

../gcc-*/configure \
  --prefix=/tools \
  --target=$LFS_TGT \
  --with-sysroot=$LFS \
  --with-local-prefix=/tools \
  --with-native-system-header-dir=/tools/include \
  --with-glibc-version=2.11 \
  --with-newlib \
  --without-headers \
  --disable-nls \
  --disable-shared \
  --disable-multilib \
  --disable-threads \
  --disable-decimal-float \
  --disable-libatomic \
  --disable-libgomp \
  --disable-libquadmath \
  --disable-libssp \
  --disable-libvtv \
  --disable-libstdcxx \
  --enable-languages=c,c++

make -j16

make install

cd $BUILD

rm -rf $BUILD/*
