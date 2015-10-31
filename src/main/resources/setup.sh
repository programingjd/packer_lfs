#!/bin/bash

echo "exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash" > ~/.bash_profile
echo "set +h" > ~/.bashrc
echo "umask 022" >> ~/.bashrc
echo "LFS=/mnt/lfs" >> ~/.bashrc
echo "LC_ALL=POSIX" >> ~/.bashrc
echo "LFS_TGT=$(uname -m)-lfs-linux-gnu" >> ~/.bashrc
echo "PATH=/tools/bin:/bin:/usr/bin" >> ~/.bashrc
echo "export LFS LC_ALL LFS_TGT PATH" >> ~/.bashrc
echo "alias ll='ls -al'" >> ~/.bashrc

sudo rm /bin/sh
sudo ln -s /bin/bash /bin/sh

sudo apt-get -q -y install gawk

sudo rm /usr/bin/awk
sudo ln -s /usr/bin/gawk /usr/bin/awk

sudo apt-get -q -y install bison
sudo rm /usr/bin/yacc
sudo ln -s /usr/bin/bison /usr/bin/yacc

LFS=/mnt/lfs
SOURCES=$LFS/sources
TOOLS=$LFS/tools
BUILD=$LFS/build

sudo mkdir -v $SOURCES
sudo chmod -v a+wt $SOURCES
sudo chown -v lfs $SOURCES

sudo mkdir -v $TOOLS
sudo ln -sv $TOOLS /
sudo chown -v lfs $TOOLS

sudo mkdir -v $BUILD
sudo chmod -v a+wt $BUILD
sudo chown -v lfs $BUILD

wget --no-verbose http://www.linuxfromscratch.org/lfs/view/stable/wget-list

wget --no-verbose --input-file=wget-list --continue --directory-prefix=$SOURCES

rm wget-list

