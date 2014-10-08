#!/bin/bash

wget http://buildroot.org/downloads/buildroot-2014.08.tar.gz
tar -xzvf buildroot-2014.08.tar.gz -C buildroot --strip-components 1
rm buildroot-2014.08.tar.gz
cd buildroot/
make clonos_defconfig
make
