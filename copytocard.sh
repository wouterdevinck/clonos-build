#!/bin/bash

# TODO A lot of error checking
# TODO Cleanup logging and messages

# Check if root

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Get command line options

usage() { echo "Usage: $0 -f fw_file -c mmc_device" 1>&2; exit 1; }

while getopts ":f:c:" o; do
    case "${o}" in
        f) fwfile=${OPTARG} ;;
        c) card=${OPTARG} ;;
        *) usage ;;
    esac
done

if [ -z "${fwfile}" ] || [ -z "${card}" ]; then
    usage
fi

# Extract firmware

tar xvf ${fwfile} -S

# Unmount all partitions on card

for n in ${card}* ; do umount $n 2>&1 ; done

# Write partitions to card

echo ""
echo "Writing partition table"
echo "======================="
echo ""

echo "o
n
p
1

+32M
t
53
n
p
2


w
" | fdisk ${card}

# Create file system and copy files

echo ""
echo "Creating ext4 file system"
echo "========================="
echo ""

# mkfs.ext4 -O ^metadata_csum,^64bit ${card}p2 # e2fsprogs >= 1.43
mkfs.ext4 ${card}p2 # e2fsprogs < 1.43

echo ""
echo "Mounting file system"
echo "===================="
echo ""

mkdir mnt
mount ${card}p2 mnt

echo ""
echo "Copying files"
echo "============="
echo ""

bsdtar -xpf rootfs.tar -C mnt
umount mnt
sync
rm -r mnt

# Write bootloader

echo ""
echo "Copying U-boot"
echo "=============="
echo ""

dd if=u-boot.sb of=${card}p1 bs=512 seek=4
sync

# Cleanup

rm rootfs.tar
rm u-boot.sb

