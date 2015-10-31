#!/bin/bash

SOURCES=/sources
BUILD=/build

tar xf $SOURCES/linux-*.tar.* --directory $BUILD
cd $BUILD/linux-*

make mrproper

make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include

cd $BUILD

rm -rf $BUILD/*


tar xf $SOURCES/glibc-*.tar.* --directory $BUILD
ln -s $BUILD/glibc-* $BUILD/glibc

cd $BUILD/glibc-*
cp $SOURCES/glibc-*_fhs*.patch ./glibc-patch1.patch
cp $SOURCES/glibc-*_i386_fix*.patch ./glibc-patch2.patch
patch -Np1 -i glibc-patch1.patch
patch -Np1 -i glibc-patch2.patch

mkdir -v ../tmp
cd ../tmp

../glibc-*/configure \
  --prefix=/usr \
  --disable-profile \
  --enable-kernel=2.6.32 \
  --enable-obsolete-rpc

make -j16

touch /etc/ld.so.conf

make install

cp -v ../glibc-*/nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

echo "passwd: files" > /etc/nsswitch.conf
echo "group: files" >> /etc/nsswitch.conf
echo "shadow: files" >> /etc/nsswitch.conf
echo "hosts: files dns" >> /etc/nsswitch.conf
echo "networks: files" >> /etc/nsswitch.conf
echo "protocols: files" >> /etc/nsswitch.conf
echo "services: files" >> /etc/nsswitch.conf
echo "ethers: files" >> /etc/nsswitch.conf
echo "rpc: files" >> /etc/nsswitch.conf

cd $BUILD

rm -rf $BUILD/*


tar xf $SOURCES/tzdata*.tar.* --directory $BUILD

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
  zic -L /dev/null -d $ZONEINFO -y "sh yearistype.sh" ${tz}
  zic -L /dev/null -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
  zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

cp -v /usr/share/zoneinfo/UTC /etc/localtime

cd $BUILD

rm -rf $BUILD/*


echo "/usr/local/lib" > /etc/ld.so.conf
echo "/opt/lib" >> /etc/ld.so.conf
echo "include /etc/ld.so.conf.d/*.conf" >> /etc/ld.so.conf

mkdir -pv /etc/ld.so.conf.d

ARCH=$(gcc -dumpmachine)
rm -f /tools/bin/ld
rm -f /tools/$ARCH/bin/ld
mv -v /tools/bin/ld-new /tools/bin/ld
ln -sv /tools/bin/ld /tools/$ARCH/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g' \
  -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
  -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
  `dirname $(gcc --print-libgcc-file-name)`/specs

