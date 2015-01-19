#!/bin/bash
# need jsawk: https://github.com/micha/jsawk

for BS in 512 4096 8192 16384 32768 65536 131072 1048576;
do
	DATA_FILE="test01_data_ss_detect_${BS}.csv"
	if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi
	echo "Round, read IOPS, write iops, total iops"  >> $DATA_FILE

	for PASS in {1..10}
	do
		READ_IOPS=$(cat fio_pass=${PASS}_rw=0_bs=${BS}.json | jsawk 'return this.jobs[0].read.iops')
		WRITE_IOPS=$(cat fio_pass=${PASS}_rw=0_bs=${BS}.json | jsawk 'return this.jobs[0].write.iops')
		echo "$PASS, $READ_IOPS, $WRITE_IOPS, $(($READ_IOPS+$WRITE_IOPS))"  >> $DATA_FILE
	done
done

exit 0
