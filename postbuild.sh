#!/bin/bash

dd if=/dev/zero of=sdimage bs=1M count=64
echo "n
p
1

+32M
t
53
n
p
2


w
" | fdisk sdimage
losetup /dev/loop0 sdimage # TODO http://unix.stackexchange.com/questions/157876/creating-disk-device-in-a-file
