# SNIA Solid State Storage (SSS) Performance Test Specification (PTS) implementation.
# See http://www.snia.org/tech_activities/standards/curr_standards/pts for more info.

# Routines

#!/bin/bash

TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
LOG_FILE=${TEST_NAME}/results/test.log
FIO="/usr/local/bin/fio"
hash $FIO 2>/dev/null || { echo >&2 "Please install fio (http://git.kernel.dk/?p=fio.git)"; exit 1; }

usage()
{
	echo "Usage: $0 /dev/<device to test>"
    exit 0
}

if [ $# -lt 1 ] ; then
	usage
fi

if [ ! -e $1 ] ; then
	usage
fi

#Results cleanup
rm -rf ${TEST_NAME}/results > /dev/null
mkdir -p ${TEST_NAME}/results

# Test and device information
echo "$TIMESTAMP Running ${TEST_NAME} on device: $1" >> $LOG_FILE
echo "Device information:" >> $LOG_FILE
hash smartctl 2>/dev/null || { echo >&2 "Please install smartctl utility from smartmontools package"; exit 1; }
smartctl -i $1 >> $LOG_FILE
echo "OIO/thread = $OIO, Threads = $THREADS" >> $LOG_FILE
$FIO --version >> $LOG_FILE

#purge the device
drive_purge ()	{
case "$1" in
SAS)
	hash sg_format 2>/dev/null || { echo >&2 "Please install sg_format utility from sg3_utils package"; exit 1; }
	sg_format --format $2
	;;
SATA)
	hash hdparm 2>/dev/null || { echo >&2 "Please install hdparm"; exit 1; }
	hdparm --user-master u --security-set-pass PasSWorD $2
	hdparm --user-master u --security-erase PasSWorD $2
	;;
esac
}

#preconditioning function
#Run SEQ Workload Independent Preconditioning - Write 2X User Capacity with 128KiB SEQ writes, writing to the entire ActiveRange without LBA restrictions

pts_precondition ()	{
$FIO --name=precondition --filename=$1 --iodepth=16 --numjobs=1 --bs=128k --ioengine=libaio --rw=write --group_reporting --direct=1 --thread --refill_buffers --loops=2
echo "$TIMESTAMP Preconditioning done" >> $LOG_FILE
}
