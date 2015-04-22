# SNIA Solid State Storage (SSS) Performance Test Specification (PTS) implementation.
# See http://www.snia.org/tech_activities/standards/curr_standards/pts for more info.

#!/bin/bash

#select drive type (SATA or SAS)
DRIVE_TYPE="SATA"
#DRIVE_TYPE="SAS"

OIO=8;
THREADS=16;
FIO="/usr/local/bin/fio"
TEST_NAME="05_Host_Idle_Recovery"
ROUNDS=360;

drive_purge ($DRIVE_TYPE, $1)

echo "11.2.3: preconditioning"

for PASS in {1..60};
	do
		$FIO --output-format=json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=60 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_precond_pass=${PASS}.json
		clear
		echo -e "`date` ${TEST_NAME} preconditioning pass $PASS of 25 done" >> $LOG_FILE
	done
echo "$TIMESTAMP Preconditioning done" >> $LOG_FILE

declare -a SUBTEST_LIST=("State_1_AB" "State_2_AB" "State_3_AB" "State_5_AB" "State_10_AB")
for SUBTEST_NAME in "${SUBTEST_LIST[@]}"
do
	case "$SUBTEST_NAME" in
		"State_1_AB")
			SLEEP_TIME=5
			;;
		"State_2_AB")
			SLEEP_TIME=10
			;;
		"State_3_AB")
			SLEEP_TIME=15
			;;
		"State_5_AB")
			SLEEP_TIME=25
			;;
		"State_10_AB")
			SLEEP_TIME=50
			;;
	esac
		
	for PASS in $(eval echo {1..$ROUNDS})
	do
		$FIO --output-format=json --output=${TEST_NAME}/results/fio_${SUBTEST_NAME}_pass=${PASS}.json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --direct=1 --norandommap --refill_buffers --thread
		sleep $SLEEP_TIME
		echo -e "$TIMESTAMP ${TEST_NAME} ${SUBTEST_NAME} pass $PASS of $ROUNDS done" >> $LOG_FILE
	done
	for PASS in $(eval echo {1..$ROUNDS})
	do
		$FIO --output-format=json --output=${TEST_NAME}/results/fio_${SUBTEST_NAME}_access-C_pass=${PASS}.json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --direct=1 --norandommap --refill_buffers --thread
		echo -e "$TIMESTAMP ${TEST_NAME} ${SUBTEST_NAME} Access C pass $PASS of $ROUNDS done" >> $LOG_FILE
	done
done

exit 0