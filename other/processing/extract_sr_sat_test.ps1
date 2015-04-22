$Rounds = 360
$TestName = 'SR_8krw_test'

#Find launch path
$scriptDirectory = Split-Path ($MyInvocation.MyCommand.Path) -Parent


$DataFile = "$TestName data.dat"
Add-Content $DataFile "Round, ReadBW, WriteBW, ReadIOPS, WriteIOPS, ReadLat, WriteLat, ReadLatMax, WriteLatMax, ReadLat99, WriteLat99, ReadLat99-9, WriteLat99-9, ReadLat99-99, WriteLat99-99"
ForEach ($Pass in (1..$Rounds))
	{
	$FioOutputJSONFile = "fio_pass=$($Pass).json"
	$FioResults = (Get-Content $FioOutputJSONFile) -join "`n" | ConvertFrom-Json
	Add-Content $DataFile "$Pass, $($FioResults.jobs[0].read.bw), $($FioResults.jobs[0].write.bw), $($FioResults.jobs[0].read.iops), $($FioResults.jobs[0].write.iops), $($FioResults.jobs[0].read.clat.mean), $($FioResults.jobs[0].write.clat.mean), $($FioResults.jobs[0].read.clat.max), $($FioResults.jobs[0].write.clat.max), $($FioResults.jobs[0].read.clat.percentile."99.000000"), $($FioResults.jobs[0].write.clat.percentile."99.000000"), $($FioResults.jobs[0].read.clat.percentile."99.900000"), $($FioResults.jobs[0].write.clat.percentile."99.900000"), $($FioResults.jobs[0].read.clat.percentile."99.990000"), $($FioResults.jobs[0].write.clat.percentile."99.990000")"
	}

