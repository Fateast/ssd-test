#!/bin/bash

#preconditioning stage

DATA_FILE="test05_data_preconditioning.csv"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

echo "Round, IOPS"  >> $DATA_FILE

for PASS in {1..25}
do
	WRITE_IOPS=$(cat fio_precond_pass=${PASS}.json | jsawk 'return this.jobs[0].write.iops')
	echo "$PASS, $WRITE_IOPS"  >> $DATA_FILE
done

#main test
DATA_FILE="test05_data.csv"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

echo "Round, IOPS"  >> $DATA_FILE

declare -a SUBTEST_LIST=("State_1_AB" "State_2_AB" "State_3_AB" "State_5_AB" "State_10_AB")
for SUBTEST_NAME in "${SUBTEST_LIST[@]}"
do
	for PASS in {1..360}
	do
		WRITE_IOPS=$(cat fio_${SUBTEST_NAME}_pass=${PASS}.json | jsawk 'return this.jobs[0].write.iops')
		echo "$PASS, $WRITE_IOPS"  >> $DATA_FILE
	done

	for PASS in {1..360}
	do
		WRITE_IOPS=$(cat fio_${SUBTEST_NAME}_access-C_pass=${PASS}.json | jsawk 'return this.jobs[0].write.iops')
		echo "$PASS, $WRITE_IOPS"  >> $DATA_FILE
	done
done

exit 0
