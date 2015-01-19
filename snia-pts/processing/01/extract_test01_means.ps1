$RWMixSet = 100, 95, 65, 50, 35, 5, 0
$BSSet = 512, 4096, 8192, 16384, 32768, 65536, 131072, 1048576

$DataFile = "test01_data_means.dat"
Add-Content $DataFile "Round, BS, RWMix, ReadIOPS, WriteIOPS"

ForEach ($RWMix in $RWMixSet) {
	ForEach ($BS in $BSSet) {
		ForEach ($Pass in (10..14)) {
		$FioResults = (Get-Content "fio_pass=${Pass}_rw=${RWMix}_bs=${BS}.json") -join "`n" | ConvertFrom-Json
		Add-Content $DataFile "$Pass, $BS, $RWMix, $($FioResults.jobs[0].read.iops), $($FioResults.jobs[0].write.iops)"
		}
	}
}

