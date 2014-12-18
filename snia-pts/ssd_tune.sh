#!/bin/bash

if [ $# -ne 1 ]
    then
    echo "Usage: $0 /dev/<device to test>"
    exit
fi

echo noop > /sys/block/$1/queue/scheduler
echo 512 > /sys/block/$1/queue/nr_requests
echo 512 > /sys/block/$1/device/queue_depth
echo 512 > /sys/block/$1/queue/max_sectors_kb
blockdev --setra 0 /dev/$1
echo "0" > /sys/block/$1/queue/rq_affinity
echo "0" > /sys/block/$1/queue/rotational
