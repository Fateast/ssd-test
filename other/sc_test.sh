#!/bin/bash

# Test for Service Cloud

readonly ROUNDS=10;
readonly FIO="/usr/local/bin/fio"
readonly TEST_NAME="SC_test"

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
#echo "Device information:" >> ${TEST_NAME}/results/test.log
#smartctl -i $1 >> ${TEST_NAME}/results/test.log

#purge the device

#sg_format --format $1
#hdparm --user-master u --security-set-pass PasSWorD $1
#hdparm --user-master u --security-erase PasSWorD $1

echo "Purge done" >> ${TEST_NAME}/results/test.log

echo "Test Start time: `date`" >> ${TEST_NAME}/results/test.log
echo

#Workload independent preconditioning

$FIO --name=precondition --filename=$1 --iodepth=16 --numjobs=1 --bs=128k --ioengine=libaio --rw=write --group_reporting --direct=1 --thread --refill_buffers --loops=2
echo "Preconditioning done" >> ${TEST_NAME}/results/test.log

#Test 
echo "${TEST_NAME}"

for OIO in 2 4 8 16 32 64 128;
	do
	for PASS in $(eval echo {1..$ROUNDS});
		do
		$FIO --output-format=json --name=job --filename=$1 --iodepth=$OIO --numjobs=1 --bssplit=4096/77:8192/3:16384/12:32768/2:65536/4:131072/2 --blockalign=4096 --percentage_random=80 --ioengine=libaio --rw=randrw --rwmixread=70 --group_reporting --runtime=60 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_iodepth=${OIO}_pass=${PASS}.json
		clear
	done
	echo -e "${TEST_NAME} OIO $OIO done"
done

exit 0
