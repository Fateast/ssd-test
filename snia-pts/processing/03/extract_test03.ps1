$Rounds = 25
$BSSet = 4096, 8192
$RWMixSet = 100, 65, 0
$TestName = 'PTS_03'

$DataFile = "$TestName data.dat"
Add-Content $DataFile "Round, RWMix, Block size, Read_AveLat, Read_MaxLat, Read_Std_Dev, Read_LatP99, Read_LatP99.9, Read_LatP99.99, Write_AveLat, Write_MaxLat, Write_Std_Dev, Write_LatP99, Write_LatP99.9, Write_LatP99.99"

ForEach ($Pass in (1..$Rounds))
{
	ForEach ($RWMix in $RWMixSet)
	{
		ForEach ($BS in $BSSet)
		{
			$FioOutputJSONFile = "fio_pass=$($Pass)_rw=$($RWMix)_bs=$($BS).json"
			$FioResults = (Get-Content $FioOutputJSONFile) -join "`n" | ConvertFrom-Json
			Add-Content $DataFile "$Pass, $RWMix, $BS, $($FioResults.jobs[0].read.clat.mean), $($FioResults.jobs[0].read.clat.max), $($FioResults.jobs[0].read.clat.stddev), $($FioResults.jobs[0].read.clat.percentile."99.000000"), $($FioResults.jobs[0].read.clat.percentile."99.900000"), $($FioResults.jobs[0].read.clat.percentile."99.990000"), $($FioResults.jobs[0].write.clat.mean), $($FioResults.jobs[0].write.clat.max), $($FioResults.jobs[0].write.clat.stddev), $($FioResults.jobs[0].write.clat.percentile."99.000000"), $($FioResults.jobs[0].write.clat.percentile."99.900000"), $($FioResults.jobs[0].write.clat.percentile."99.990000")"
		}
	}
}

