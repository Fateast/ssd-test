#!/bin/bash
for BS in 512 4096 8192;
do
	DATA_FILE="test03_data_ss_detect_${BS}.csv"
	if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

	echo "Round, Block_size, write clat ave"  >> $DATA_FILE

	for PASS in {1..25}
	do
		WRITE_LAT_AVE=$(cat fio_pass=${PASS}_rw=0_bs=${BS}.json | jsawk 'return this.jobs[0].write.clat.mean')
		echo "$PASS, $BS, $WRITE_LAT_AVE"  >> $DATA_FILE
	done
done

exit 0
