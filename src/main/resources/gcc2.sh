#!/bin/bash

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

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h


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

CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../gcc-*/configure \
  --prefix=/tools \
  --with-local-prefix=/tools \
  --with-native-system-header-dir=/tools/include \
  --enable-languages=c,c++ \
  --disable-libstdcxx-pch \
  --disable-multilib \
  --disable-bootstrap \
  --disable-libgomp

make -j16

make install

ln -sv gcc /tools/bin/cc

cd $BUILD

rm -rf $BUILD/*
