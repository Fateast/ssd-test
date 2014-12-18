#!/bin/bash
readonly OIO=8;
readonly THREADS=16;
readonly ROUNDS=25;
readonly FIO="/usr/local/bin/fio"
readonly TEST_NAME="05_Host_Idle_Recovery"

if [ $# -ne 1 ]
then
  echo "Usage: $0 /dev/<device to test>"
  exit
fi

#The output from a test run is placed in the ./results folder.
#This folder is recreated after every run.
rm -f ${TEST_NAME}/results/* > /dev/null
rmdir ${TEST_NAME}/results > /dev/null
mkdir -p ${TEST_NAME}/results


echo "Running ${TEST_NAME} on device: $1" >> ${TEST_NAME}/results/test.log
echo "Device information:" >> ${TEST_NAME}/results/test.log
smartctl -i $1 >> ${TEST_NAME}/results/test.log

#purge the device

hdparm --user-master u --security-set-pass PasSWorD $1
hdparm --user-master u --security-erase PasSWorD $1

echo "Purge done" >> ${TEST_NAME}/results/test.log

echo "OIO/thread = $OIO, Threads = $THREADS" >> ${TEST_NAME}/results/test.log
echo "Test Start time: `date`" >> ${TEST_NAME}/results/test.log
echo

echo "11.2.3: preconditioning"

for PASS in {1..25};
	do
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=60 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_precond_pass=${PASS}.log
		clear
		echo -e "${TEST_NAME} preconditioning pass $PASS of 25 done" >> ${TEST_NAME}/results/test.log
	done
echo "Preconditioning done" >> ${TEST_NAME}/results/test.log


# 11.2.4 Wait State 1 Segment Including Return To Baseline
echo "11.2.4.1: Wait State 1 Segment, Access A + Access B"

for PASS in {1..360};
	do
#Access A
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state1_pass=${PASS}.log
#Access B
		sleep 5
		clear
		echo "Wait State 1, Access A+B, pass ${PASS} done"
	done


echo "11.2.4.2: Wait State 1 Segment, Access C"

for PASS in {1..360};
	do
#Access C
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state1_C_pass=${PASS}.log
		clear
		echo "Wait State 1, Access C, pass ${PASS} done"
	done

echo "Wait state 1, Access C done"

# 11.2.5 Wait State 2 Segment Including Return To Baseline
echo "11.2.5.1: Wait State 2 Segment, Access A + Access B"

for PASS in {1..360};
	do
#Access A
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state2_pass=${PASS}.log
#Access B
		sleep 10
		clear
		echo "Wait State 2, Access A+B, pass ${PASS} done"
	done


echo "11.2.5.2: Wait State 1 Segment, Access C"

for PASS in {1..360};
	do
#Access C
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state2_C_pass=${PASS}.log
		clear
		echo "Wait State 2, Access C, pass ${PASS} done"
	done

echo "Wait state 1, Access C done"

# 11.2.6 Wait State 3 Segment Including Return To Baseline
echo "11.2.6.1: Wait State 3 Segment, Access A + Access B"

for PASS in {1..360};
	do
#Access A
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state3_pass=${PASS}.log
#Access B
		sleep 15
		clear
		echo "Wait State 3, Access A+B, pass ${PASS} done"
	done


echo "11.2.6.2: Wait State 3 Segment, Access C"

for PASS in {1..360};
	do
#Access C
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state3_C_pass=${PASS}.log
		clear
		echo "Wait State 3, Access C, pass ${PASS} done"
	done

echo "Wait state 3, Access C done"


# 11.2.7 Wait State 5 Segment Including Return To Baseline
echo "11.2.7.1: Wait State 5 Segment, Access A + Access B"

for PASS in {1..360};
	do
#Access A
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state5_pass=${PASS}.log
#Access B
		sleep 25
		clear
		echo "Wait State 5, Access A+B, pass ${PASS} done"
	done


echo "11.2.7.2: Wait State 5 Segment, Access C"

for PASS in {1..360};
	do
#Access C
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state5_C_pass=${PASS}.log
		clear
		echo "Wait State 5, Access C, pass ${PASS} done"
	done

echo "Wait state 5, Access C done"

# 11.2.8 Wait State 10 Segment Including Return To Baseline
echo "11.2.8.1: Wait State 10 Segment, Access A + Access B"

for PASS in {1..360};
	do
#Access A
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state10_pass=${PASS}.log
#Access B
		sleep 50
		clear
		echo "Wait State 10, Access A+B, pass ${PASS} done"
	done


echo "11.2.8.2: Wait State 10 Segment, Access C"

for PASS in {1..360};
	do
#Access C
		$FIO --minimal --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=5 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_state10_C_pass=${PASS}.log
		clear
		echo "Wait State 10, Access C, pass ${PASS} done"
	done

echo "Wait state 10, Access C done"

exit

