#!/bin/bash

readonly OIO=16;
readonly THREADS=16;
readonly ROUNDS=360;
readonly FIO="/usr/local/bin/fio"
readonly TEST_NAME="Preconditioning_Curve_8k_Read-Write"

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
echo "Running ${TEST_NAME} on device: $1" > ${TEST_NAME}/results/test.log
#echo "Device information:" >> ${TEST_NAME}/results/test.log
#smartctl -i $1 >> ${TEST_NAME}/results/test.log

#purge the device

#hdparm --user-master u --security-set-pass PasSWorD $1
#hdparm --user-master u --security-erase PasSWorD $1

dd if=/dev/zero | pv | dd of=$1 bs=1M

echo "Purge done" >> ${TEST_NAME}/results/test.log

echo "OIO/thread = $OIO, Threads = $THREADS" >> ${TEST_NAME}/results/test.log
echo "Test Start time: `date`" >> ${TEST_NAME}/results/test.log
echo

#Main test 
echo "${TEST_NAME}"

for PASS in {1..360};
do
	$FIO --output-format=json --name=job --filename=$1 --iodepth=$OIO --numjobs=$THREADS --bs=8192 --ioengine=libaio --rw=randrw --rwmixread=70 --group_reporting --runtime=60 --time_based --direct=1 --randrepeat=0 --norandommap --thread --refill_buffers --output=${TEST_NAME}/results/fio_pass=${PASS}.json
	clear
    echo -e "${TEST_NAME} pass $PASS of 360 done" >> ${TEST_NAME}/results/test.log
done

exit

