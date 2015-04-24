# SNIA Solid State Storage (SSS) Performance Test Specification (PTS) implementation.
# See http://www.snia.org/tech_activities/standards/curr_standards/pts for more info.

#!/bin/bash

#Throughtput Test (modified: added qd=32, excluded 512 byte block size)

#select drive type (SATA or SAS)
DRIVE_TYPE="SATA"
#DRIVE_TYPE="SAS"
#DRIVE_TYPE="virident"

OIO=1;
THREADS=1;
ROUNDS=25;
TEST_NAME="03_Latency_test"
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
LOG_FILE=${TEST_NAME}/results/test.log
FIO="/usr/local/bin/fio"

source test_routines.sh

drive_purge $DRIVE_TYPE $1
pts_precondition $1

echo "$TIMESTAMP Starting test $TEST_NAME" >> $LOG_FILE

#Test 
echo "Starting test $TEST_NAME"

for PASS in $(eval echo {1..$ROUNDS});
do
	for OIO in 1 32;
	do
		for RWMIX in 100 65 0;
		do
			for BS in 4096 8192;
			do
				$FIO --output-format=json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=$BS --ioengine=libaio --rw=randrw --rwmixread=$RWMIX --group_reporting --runtime=60 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_pass=${PASS}_oio=${OIO}_rw=${RWMIX}_bs=${BS}.json
			done
		done
	done
	clear
    echo -e "$TIMESTAMP ${TEST_NAME} pass $PASS of $ROUNDS done" >> $LOG_FILE
done

exit 0


