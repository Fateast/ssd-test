#!/bin/bash
# need jsawk: https://github.com/micha/jsawk

DATA_FILE="test01_data_means.dat"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

echo "Round, RW_mix, Block_size, read IOPS, write iops, total iops"  >> $DATA_FILE


for RWMIX in 100 95 65 50 35 5 0;
do
	for BS in 512 4096 8192 16384 32768 65536 131072 1048576;
	do
		for PASS in {10..14}
		do
			READ_IOPS=$(cat fio_pass=${PASS}_rw=${RWMIX}_bs=${BS}.json | jsawk 'return this.jobs[0].read.iops')
			WRITE_IOPS=$(cat fio_pass=${PASS}_rw=${RWMIX}_bs=${BS}.json | jsawk 'return this.jobs[0].write.iops')
			echo "$PASS, $BS, $RWMIX, $READ_IOPS, $WRITE_IOPS, $(($READ_IOPS+$WRITE_IOPS))"  >> $DATA_FILE
		done
	done
done

exit 0
