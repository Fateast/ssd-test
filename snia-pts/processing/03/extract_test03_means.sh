#!/bin/bash

DATA_FILE="test03_data_means.csv"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

echo "Round, RW_mix, Block_size, Read Ave lat, Read Max lat, Write Ave lat, Write Max lat"  >> $DATA_FILE

for PASS in {14..18}
do
	for RWMIX in 100 65 0;
	do
		for BS in 512 4096 8192;
		do
			READ_LAT=$(cat fio_pass=${PASS}_rw=${RWMIX}_bs=${BS}.json | jsawk 'return this.jobs[0].read.clat.mean')
			WRITE_LAT=$(cat fio_pass=${PASS}_rw=${RWMIX}_bs=${BS}.json | jsawk 'return this.jobs[0].write.clat.mean')
			READ_LAT_MAX=$(cat fio_pass=${PASS}_rw=${RWMIX}_bs=${BS}.json | jsawk 'return this.jobs[0].read.clat.max')
			WRITE_LAT_MAX=$(cat fio_pass=${PASS}_rw=${RWMIX}_bs=${BS}.json | jsawk 'return this.jobs[0].write.clat.max')
			echo "$PASS, $RWMIX, $BS, $READ_LAT, $READ_LAT_MAX, $WRITE_LAT, $WRITE_LAT_MAX"  >> $DATA_FILE
		done
	done
done

exit 0
