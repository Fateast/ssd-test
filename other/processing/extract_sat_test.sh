#!/bin/bash

DATA_FILE="test04_data.csv"
if [ -f $DATA_FILE ]; then rm $DATA_FILE; fi

echo "Round, Read IOPS, Read Lat Mean, Read Lat Max, Read Lat Std Deviation, Write IOPS, Write Lat Mean, Write Lat Max, Write Lat Std Deviation, Total IOPS, Total Lat Mean, Total Lat Max, Total Lat Std Deviation"  >> $DATA_FILE

for PASS in {1..360}
do
	READ_IOPS=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].read.iops')
	READ_LAT=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].read.clat.mean')
	READ_LAT_MAX=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].read.clat.max')
	READ_LAT_STDDEV=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].read.clat.stddev')
	WRITE_IOPS=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].write.iops')
	WRITE_LAT=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].write.clat.mean')
	WRITE_LAT_MAX=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].write.clat.max')
	WRITE_LAT_STDDEV=$(cat fio_pass=${PASS}.json | jsawk 'return this.jobs[0].write.clat.stddev')
	TOTAL_IOPS=$(echo $READ_IOPS+$WRITE_IOPS | bc -l)
	TOTAL_LAT=$(echo $READ_LAT+$WRITE_LAT | bc -l)
	TOTAL_LAT_MAX=$(echo $READ_LAT_MAX+$WRITE_LAT_MAX | bc -l)
	TOTAL_LAT_STDDEV=$(echo $READ_LAT_STDDEV+$WRITE_LAT_STDDEV | bc -l)
	echo "$PASS, $READ_IOPS, $READ_LAT, $READ_LAT_MAX, $READ_LAT_STDDEV, $WRITE_IOPS, $WRITE_LAT, $WRITE_LAT_MAX, $WRITE_LAT_STDDEV, $TOTAL_IOPS, $TOTAL_LAT, $TOTAL_LAT_MAX, $TOTAL_LAT_STDDEV"  >> $DATA_FILE
done

exit 0
