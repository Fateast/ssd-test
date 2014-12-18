#!/bin/bash

readonly OIO=16;
readonly THREADS=8;
readonly ROUNDS=600;
readonly FIO="/usr/local/bin/fio"
readonly TEST_NAME="04_Write_Saturation_test"

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

hdparm --user-master u --security-set-pass PasSWorD $1
hdparm --user-master u --security-erase PasSWorD $1

echo "Purge done" >> ${TEST_NAME}/results/test.log

echo "OIO/thread = $OIO, Threads = $THREADS" >> ${TEST_NAME}/results/test.log
echo "Test Start time: `date`" >> ${TEST_NAME}/results/test.log
echo

#Workload independent preconditioning
#Run SEQ Workload Independent Preconditioning - Write 2X User Capacity with 128KiB SEQ writes, writing to the entire ActiveRange without LBA restrictions
echo "Preconditioning pass 1" >> ${TEST_NAME}/results/test.log
$FIO --name=precondition --filename=$1 --iodepth=16 --numjobs=1 --bs=128k --ioengine=libaio --rw=write --group_reporting --direct=1 --thread --refill_buffers
echo
echo "Preconditioning pass 2" >> ${TEST_NAME}/results/test.log
$FIO --name=precondition --filename=$1 --iodepth=16 --numjobs=1 --bs=128k --ioengine=libaio --rw=write --group_reporting --direct=1 --thread --refill_buffers

#Main test 
echo "${TEST_NAME}"

for PASS in {1..600};
do
	$FIO --output-format=json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=4096 --ioengine=libaio --rw=randwrite --group_reporting --runtime=60 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_pass=${PASS}.json
	clear
    echo -e "${TEST_NAME} pass $PASS of 600 done" >> ${TEST_NAME}/results/test.log
done

exit

