#!/bin/sh

CHANNEL=http://icecast.vrtcdn.be/stubru-high.mp3
VOLUME=0.05

while true
do
    ping -c 1 8.8.8.8
    if [ $? -eq 0 ];
    then
        echo "Network available."
        break
    else
        echo "Network is not available, waiting..."
        sleep 5
    fi
done

gst-launch-1.0 \
    souphttpsrc location=$CHANNEL \
    ! queue2 \
    ! icydemux \
    ! mpegaudioparse \
    ! mpg123audiodec \
    ! volume volume=$VOLUME \
    ! alsasink