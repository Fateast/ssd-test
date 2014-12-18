#!/bin/bash

DATA_FILE="test01_data_means.dat"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

echo "Round, RW_mix, Block_size, read IOPS, write iops, total iops"  >> $DATA_FILE


for RWMIX in 100 95 65 50 35 5 0;
do
	for BS in 512 4096 8192 16384 32768 65536 131072 1048576;
	do
		for PASS in {6..10}
		do
			while IFS=';' read -r -a FIO_OUT
			do
				READ_IOPS=${FIO_OUT[7]}
				WRITE_IOPS=${FIO_OUT[48]}
				echo "$PASS, $RWMIX, $BS, $READ_IOPS, $WRITE_IOPS, $(($READ_IOPS+$WRITE_IOPS))"  >> $DATA_FILE
			done < fio_pass=${PASS}_rw=${RWMIX}_bs=${BS}.log
		done
	done
done

exit 0
