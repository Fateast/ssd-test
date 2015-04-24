$Rounds = 600
$TestName = 'PTS_04'

$DataFile = "$TestName data.dat"
Add-Content $DataFile "Round, IOPS, AveLat, MaxLat, Std Deviation, LatP99, LatP99.9, LatP99.99"
ForEach ($Pass in (1..$Rounds))
{
	$FioOutputJSONFile = "fio_pass=$($Pass).json"
	$FioResults = (Get-Content $FioOutputJSONFile) -join "`n" | ConvertFrom-Json
	Add-Content $DataFile "$Pass, $($FioResults.jobs[0].write.iops), $($FioResults.jobs[0].write.clat.mean), $($FioResults.jobs[0].write.clat.max), $($FioResults.jobs[0].write.clat.stddev), $($FioResults.jobs[0].write.clat.percentile."99.000000"), $($FioResults.jobs[0].write.clat.percentile."99.900000"), $($FioResults.jobs[0].write.clat.percentile."99.990000")"
}

