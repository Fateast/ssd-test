$Rounds = 25
$TestName = 'PTS_03v2'

$DataFile = "$($TestName)_data_4k_write.csv"
Add-Content $DataFile "Round, Write_AveLat"

ForEach ($Pass in (1..$Rounds))
{
	$FioOutputJSONFile = "fio_pass=$($Pass)_QD=16_TC=8_rw=0_bs=4096.json"
	$FioResults = (Get-Content $FioOutputJSONFile) -join "`n" | ConvertFrom-Json
	Add-Content $DataFile "$Pass, $($FioResults.jobs[0].write.clat.mean)"
}