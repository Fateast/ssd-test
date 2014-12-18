#!/bin/bash

DATA_FILE="test02_data_write_1m.csv"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

for PASS in {1..10}
do
	WRITE_BAND=$(cat fio_pass=${PASS}_rw=0_bs=1048576.json | jsawk 'return this.jobs[0].write.bw' )
	echo "$PASS, $WRITE_BAND"  >> $DATA_FILE
done

DATA_FILE="test02_data_read_1m.csv"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

for PASS in {1..10}
do
	READ_BAND=$(cat fio_pass=${PASS}_rw=100_bs=1048576.json | jsawk 'return this.jobs[0].read.bw' )
	echo "$PASS, $READ_BAND"  >> $DATA_FILE
done

exit 0
