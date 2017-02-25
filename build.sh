#!/bin/bash

BR_VERSION=buildroot-2017.02-rc2

wget https://buildroot.org/downloads/$BR_VERSION.tar.gz -O buildroot.tar.gz
tar -xzvf buildroot.tar.gz -C buildroot --strip-components 1
rm buildroot.tar.gz
cd buildroot/
make clonos_defconfig
make
