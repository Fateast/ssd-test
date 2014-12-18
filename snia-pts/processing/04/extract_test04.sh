#!/bin/bash

DATA_FILE="test04_data.csv"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

echo "Round, IOPS, AveLat, MaxLat, Std Deviation"  >> $DATA_FILE

for PASS in {1..600}
do
	WRITE_IOPS=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].write.iops')
	WRITE_LAT=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].write.clat.mean')
	WRITE_LAT_MAX=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].write.clat.max')
	WRITE_LAT_STD_DEV=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].write.clat.stddev')
	echo "$PASS, $WRITE_IOPS, $WRITE_LAT, $WRITE_LAT_MAX, $WRITE_LAT_STD_DEV"  >> $DATA_FILE
done

exit 0
