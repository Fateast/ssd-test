# SNIA Solid State Storage (SSS) Performance Test Specification (PTS) implementation.
# See http://www.snia.org/tech_activities/standards/curr_standards/pts for more info.

#!/bin/bash

# SNIA PTS Test 04: Write Saturation

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

readonly OIO=16;
readonly THREADS=8;
readonly ROUNDS=600;
FIO=`find_prog /usr/local/bin/fio`>|| exit 1
readonly TEST_NAME="04_Write_Saturation_test"
LOG_FILE=${TEST_NAME}/results/test.log
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`

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

#purge the device

hdparm --user-master u --security-set-pass PasSWorD $1
hdparm --user-master u --security-erase PasSWorD $1

echo "$TIMESTAMP Purge done" >> $LOG_FILE

echo "OIO/thread = $OIO, Threads = $THREADS" >> $LOG_FILE
$FIO --version >> $LOG_FILE
echo "Test Start time: `date`" >> $LOG_FILE

#Workload independent preconditioning
#Run SEQ Workload Independent Preconditioning - Write 2X User Capacity with 128KiB SEQ writes, writing to the entire ActiveRange without LBA restrictions

$FIO --name=precondition --filename=$1 --iodepth=16 --numjobs=1 --bs=128k --ioengine=libaio --rw=write --group_reporting --direct=1 --thread --refill_buffers --loops=2
echo "$TIMESTAMP Preconditioning done" >> $LOG_FILE

echo "$TIMESTAMP Starting test $TEST_NAME" >> $LOG_FILE

#Test 
echo "Starting test $TEST_NAME"

for PASS in $(eval echo {1..$ROUNDS});
do
	$FIO --output-format=json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=60 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_pass=${PASS}.json
	clear
    echo -e "$TIMESTAMP ${TEST_NAME} pass $PASS of $ROUNDS done" >> $LOG_FILE
done

exit 0

