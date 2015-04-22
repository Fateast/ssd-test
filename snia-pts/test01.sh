# SNIA Solid State Storage (SSS) Performance Test Specification (PTS) implementation.
# See http://www.snia.org/tech_activities/standards/curr_standards/pts for more info.

#!/bin/bash

#IOPS Test

#select drive type (SATA or SAS)
DRIVE_TYPE="SATA"
#DRIVE_TYPE="SAS"

OIO=8;
THREADS=16;
ROUNDS=25;
TEST_NAME="01_IOPS_test"

source test_routines.sh

drive_purge ($DRIVE_TYPE, $1)
pts_precondition ($1)

echo "$TIMESTAMP Starting test $TEST_NAME" >> $LOG_FILE

#Test 
echo "Starting test $TEST_NAME"

for PASS in $(eval echo {1..$ROUNDS});
  do
  for RWMIX in 100 95 65 50 35 5 0;
    do
    for BS in 512 4096 8192 16384 32768 65536 131072 1048576;
      do
      $FIO --output-format=json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=$BS --ioengine=libaio --rw=randrw --rwmixread=$RWMIX --group_reporting --runtime=60 --direct=1 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_pass=${PASS}_rw=${RWMIX}_bs=${BS}.json
	  clear
    done
  done
  echo -e "$TIMESTAMP ${TEST_NAME} pass $PASS of $ROUNDS done" >> $LOG_FILE
done

exit 0
