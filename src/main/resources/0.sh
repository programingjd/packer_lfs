#!/bin/sh
apt-get autoremove -y xserver-common
dd if=/dev/zero of=$HOME/zerofill bs=1k count=1000000k
rm $HOME/zerofill
