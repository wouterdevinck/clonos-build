#!/bin/bash
set -e

BR_VERSION=2019.02.1

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
WORKDIR="$SCRIPT_DIR/buildroot"
EXTDIR="$SCRIPT_DIR/external"
OUTDIR="$SCRIPT_DIR/output"

function printUsage {
  echo "Usage: $0 prepare|menuconfig|build|flash|monitor|clean"
  echo ""
  echo "   prepare    - Download buildroot and unpack into working directory."
  echo "   menuconfig - Run the menuconfig utility."
  echo "   build      - Build the image."
  echo "   flash      - Write the image to an SD card."
  echo "   monitor    - Connect to the serial port."
  echo "   clean      - Clean up."
  echo ""
}

case $1 in

"prepare")
  rm -rf $WORKDIR
  mkdir -p $WORKDIR
  wget "https://buildroot.org/downloads/buildroot-$BR_VERSION.tar.gz"
  tar -xzf buildroot-$BR_VERSION.tar.gz -C $WORKDIR --strip-components 1
  rm buildroot-$BR_VERSION.tar.gz
  ;;

"build"|"menuconfig")
  if [ ! -d "$WORKDIR" ]; then
    printf "\nPlease run prepare first.\n\n"
    exit 2
  fi
  cd $WORKDIR
  ;;&

"menuconfig")
  make O=$OUTDIR BR2_EXTERNAL=$EXTDIR menuconfig
  make O=$OUTDIR savedefconfig
  ;;

"build")
  make O=$OUTDIR BR2_EXTERNAL=$EXTDIR clonos_defconfig
  make O=$OUTDIR 
  ;;

"flash")
  sudo dd if=$OUTDIR/images/sdcard.img of=/dev/mmcblk0 status=progress
  sync
  ;;

"monitor")
  gtkterm -p /dev/ttyUSB1 -s 115200
  ;;

"clean")
  rm -rf $WORKDIR $OUTDIR
  ;;

*)
  printUsage
  ;;

esac
