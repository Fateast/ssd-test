$Rounds = 10
$ThreadsSet = 2, 4, 8, 16
$QDSet = 2, 4, 8, 16
$TestName = 'SR04'

$DataFile = "$TestName data.dat"
Add-Content $DataFile "Round, TC, QD, Read IOPS, Write IOPS, Read_AveLat, Read_MaxLat, Read_Std_Dev, Read_LatP99, Read_LatP99.9, Read_LatP99.99, Write_AveLat, Write_MaxLat, Write_Std_Dev, Write_LatP99, Write_LatP99.9, Write_LatP99.99"

ForEach ($Pass in (1..$Rounds))
{
	ForEach ($Threads in $ThreadsSet)
	{
		ForEach ($QD in $QDSet)
		{
			$FioOutputJSONFile = "fio_pass=$($Pass)_oio=$($QD)_tc=$($Threads).json"
			$FioResults = (Get-Content $FioOutputJSONFile) -join "`n" | ConvertFrom-Json
			Add-Content $DataFile "$Pass, $Threads, $QD, $($FioResults.jobs[0].read.iops), $($FioResults.jobs[0].write.iops), $($FioResults.jobs[0].read.clat.mean), $($FioResults.jobs[0].read.clat.max), $($FioResults.jobs[0].read.clat.stddev), $($FioResults.jobs[0].read.clat.percentile."99.000000"), $($FioResults.jobs[0].read.clat.percentile."99.900000"), $($FioResults.jobs[0].read.clat.percentile."99.990000"), $($FioResults.jobs[0].write.clat.mean), $($FioResults.jobs[0].write.clat.max), $($FioResults.jobs[0].write.clat.stddev), $($FioResults.jobs[0].write.clat.percentile."99.000000"), $($FioResults.jobs[0].write.clat.percentile."99.900000"), $($FioResults.jobs[0].write.clat.percentile."99.990000")"
		}
	}
}

