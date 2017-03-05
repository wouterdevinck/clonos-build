#!/bin/bash

IMG_NAME=sdcard.img

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Creating image file"
echo "==================="
echo ""

dd if=/dev/zero of=$IMG_NAME bs=1M count=64

echo ""
echo "Writing partition table"
echo "======================="
echo ""

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
" | fdisk $IMG_NAME

echo ""
echo "Setting up loop device"
echo "======================"
echo ""

losetup -o 34603008 --sizelimit 67108352 /dev/loop0 $IMG_NAME

echo ""
echo "Creating ext4 file system"
echo "========================="
echo ""

mkfs.ext4 -O ^metadata_csum,^64bit /dev/loop0

echo ""
echo "Mounting file system"
echo "===================="
echo ""

mkdir mnt
mount /dev/loop0 mnt

echo ""
echo "Copying files"
echo "============="
echo ""

bsdtar -xpf buildroot/output/images/rootfs.tar -C mnt

echo ""
echo "Copying U-boot"
echo "=============="
echo ""

dd if=buildroot/output/images/u-boot.sb of=$IMG_NAME bs=512 seek=4
sync

echo ""
echo "Cleanup"
echo "======="
echo ""

umount mnt
sync
losetup -d /dev/loop0
rm -r mnt
