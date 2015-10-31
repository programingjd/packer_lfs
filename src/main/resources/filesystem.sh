#!/bin/bash

mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v  /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}

case $(uname -m) in
  x86_64) ln -sv lib /lib64
          ln -sv lib /usr/lib64
          ln -sv lib /usr/local/lib64 ;;
esac

mkdir -v /var/{log,mail,spool}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}

ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin
#ln -sv /tools/bin/perl /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
#ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib
sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
ln -sv bash /bin/sh

ln -sv /proc/self/mounts /etc/mtab

echo "root:x:0:0:root:/root:/bin/bash" > /etc/passwd
echo "bin:x:1:1:bin:/dev/null:/bin/false" >> /etc/passwd
echo "daemon:x:6:6:Daemon User:/dev/null:/bin/false" >> /etc/passwd
echo "messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false" >> /etc/passwd
echo "nobody:x:99:99:Unprivileged User:/dev/null:/bin/false" >> /etc/passwd

echo "root:x:0:" > /etc/group
echo "root:x:0:" >> /etc/group
echo "bin:x:1:daemon" >> /etc/group
echo "sys:x:2:" >> /etc/group
echo "kmem:x:3:" >> /etc/group
echo "tape:x:4:" >> /etc/group
echo "tty:x:5:" >> /etc/group
echo "daemon:x:6:" >> /etc/group
echo "floppy:x:7:" >> /etc/group
echo "disk:x:8:" >> /etc/group
echo "lp:x:9:" >> /etc/group
echo "dialout:x:10:" >> /etc/group
echo "audio:x:11:" >> /etc/group
echo "video:x:12:" >> /etc/group
echo "utmp:x:13:" >> /etc/group
echo "usb:x:14:" >> /etc/group
echo "cdrom:x:15:" >> /etc/group
echo "adm:x:16:" >> /etc/group
echo "messagebus:x:18:" >> /etc/group
echo "systemd-journal:x:23:" >> /etc/group
echo "input:x:24:" >> /etc/group
echo "mail:x:34:" >> /etc/group
echo "nogroup:x:99:" >> /etc/group
echo "users:x:999:" >> /etc/group

