#!/bin/bash

# Storagereview variable OIO and TC Test

readonly ROUNDS=10;
readonly FIO="/usr/local/bin/fio"
readonly TEST_NAME="SR_test_04_QD"

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

# Test and device information
echo "Running ${TEST_NAME} on device: $1" >> ${TEST_NAME}/results/test.log
echo "Device information:" >> ${TEST_NAME}/results/test.log
smartctl -i $1 >> ${TEST_NAME}/results/test.log

#purge the device

sg_format --format $1
#hdparm --user-master u --security-set-pass PasSWorD $1
#hdparm --user-master u --security-erase PasSWorD $1

echo "Purge done" >> ${TEST_NAME}/results/test.log

echo "Test Start time: `date`" >> ${TEST_NAME}/results/test.log
echo

#Workload independent preconditioning
#Run SEQ Workload Independent Preconditioning - Write 2X User Capacity with 128KiB SEQ writes, writing to the entire ActiveRange without LBA restrictions

$FIO --name=precondition --filename=$1 --iodepth=16 --numjobs=1 --bs=128k --ioengine=libaio --rw=write --group_reporting --direct=1 --thread --refill_buffers --loops=2
echo "Preconditioning done" >> ${TEST_NAME}/results/test.log

#Test 
echo "${TEST_NAME}"

for THREADS in 2 4 8 16;
	do
	for OIO in 2 4 8 16;
		do
		for PASS in {1..10};
			do
			$FIO --output-format=json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=8192 --ioengine=libaio --rw=randrw --rwmixread=70 --group_reporting --runtime=60 --direct=1 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_pass=${PASS}_oio=${OIO}_tc=${THREADS}.json
			clear
		done
		echo -e "${TEST_NAME} OIO $OIO threads $THREADS done"
	done
	echo -e "${TEST_NAME} threads $THREADS OIO $OIO done"
done

exit 0
