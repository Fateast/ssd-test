# Solid State Storage Performance Test Specification Client v1.1 implementation.
# See http://www.snia.org/tech_activities/standards/curr_standards/pts for more info.

#!/bin/bash

# IOPS Test

usage()
{
	echo "Usage: $0 /dev/<device to test>"
    exit 0
}

function find_prog(){
	prog="$1"
		if [ ! -x "$prog" ]; then
		prog="${prog##*/}"
		p=`type -f -P "$prog" 2>/dev/null`
		if [ "$p" = "" ]; then
			[ "$2" != "quiet" ] && echo "$1: needed but not found, aborting." >&2
			exit 1
		fi
		prog="$p"
		[ $verbose -gt 0 ] && echo "  --> using $prog instead of $1" >&2
	fi
	echo "$prog"
}

OIO=8;
THREADS=16;
ROUNDS=25;
FIO=`find_prog /usr/local/bin/fio`>|| exit 1
TEST_NAME="SNIA PTS-C Test 1"
LOG_FILE=${TEST_NAME}/results/test.log
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`

declare -a RW_MIX_LIST=(100 95 65 50 35 5 0)
# Don't use 512 byte BS for devices which report 4096 byte physical block size (aka 512E)
#declare -a BS_LIST=(1048576 131072 65536 32768 16384 8192 4096 512)
declare -a BS_LIST=(1048576 131072 65536 32768 16384 8192 4096)

declare -a ACT_RANGES=(100 75)
declare -a ACT_RANGE_AMOUNTS_KiB=(8388608 16777216)
ACT_ZONES=2048

# SSD device size in bytes
DEV_SIZE=`blockdev --getsize64 $1`

if [ $# -lt 1 ] ; then
	usage
fi

if [ ! -e $1 ] ; then
	usage
fi

#The output from a test run is placed in the ./results folder.
#This folder is recreated after every run.

rm -rf ${TEST_NAME}/results > /dev/null
mkdir -p ${TEST_NAME}/results

# Test and device information
echo "$TIMESTAMP Running ${TEST_NAME} on device: $1" >> $LOG_FILE

echo "Device information:" >> $LOG_FILE
smartctl -i $1 >> $LOG_FILE

for for ACT_RANGE in "${ACT_RANGES[@]}"
do
	for for ACT_RANGE_AMOUNT in "${ACT_RANGE_AMOUNTS_KiB[@]}"
	do
		# Calculate offsets for active zones
		# TODO: add rounding
		ZONESIZE=echo "$DEV_SIZE / $ACT_ZONES" | bc -l
		
		# Purge the device
		#hdparm --user-master u --security-set-pass PasSWorD $1
		#hdparm --user-master u --security-erase PasSWorD $1
		dd if=/dev/zero of=$1 bs=1M
		echo "$TIMESTAMP Purge done" >> $LOG_FILE

		echo "OIO/thread = $OIO, Threads = $THREADS" >> $LOG_FILE
		$FIO --version >> $LOG_FILE
		echo "Test Start time: `date`, Active Range = ${ACT_RANGE}, Active Range Amount(KiB) = ${ACT_RANGE_AMOUNT}" >> $LOG_FILE
		
		#Workload independent preconditioning
		#Run SEQ Workload Independent Preconditioning - Write 2X User Capacity with 128KiB SEQ writes, writing to the entire ActiveRange without LBA restrictions

		$FIO --name=precondition --filename=$1 --iodepth=16 --numjobs=1 --bs=128k --ioengine=libaio --rw=write --group_reporting --direct=1 --thread --refill_buffers --loops=2
		echo "$TIMESTAMP Preconditioning done" >> $LOG_FILE
		
		for PASS in $(eval echo {1..$ROUNDS});
		do
			for RWMIX in 100 95 65 50 35 5 0;
			do
				for BS in 512 4096 8192 16384 32768 65536 131072 1048576;
				do
				$FIO --output-format=json --name=job --filename=$1 --zonesize=$ZONESIZE --zonerange=$ZONERANGE --zoneskip=$ZONESKIP --iodepth=$OIO --numjobs=$THREADS --bs=$BS --ioengine=libaio --rw=randrw --rwmixread=$RWMIX --group_reporting --runtime=60 --direct=1 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_range=${ACT_RANGE}_range_amt=${ACT_RANGE_AMOUNT}_pass=${PASS}_rw=${RWMIX}_bs=${BS}.json
				clear
				done
			done
		  echo -e "$TIMESTAMP ${TEST_NAME} pass $PASS of $ROUNDS done" >> $LOG_FILE
		done
	done
done

exit 0
