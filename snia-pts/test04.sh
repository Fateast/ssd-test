# SNIA Solid State Storage (SSS) Performance Test Specification (PTS) implementation.
# See http://www.snia.org/tech_activities/standards/curr_standards/pts for more info.

#!/bin/bash

# SNIA PTS Test 04: Write Saturation

#select drive type (SATA or SAS)
DRIVE_TYPE="SATA"
#DRIVE_TYPE="SAS"

OIO=16;
THREADS=8;
ROUNDS=600;
TEST_NAME="04_Write_Saturation_test"

source test_routines.sh

drive_purge ($DRIVE_TYPE, $1)
pts_precondition ($1)

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

