#!/usr/bin/gnuplot
#7.3.6.2 IOPS Measurement Plot – 2D
set terminal pngcairo size 1280, 1024 enhanced font "/usr/share/fonts/LiberationMono-Regular.ttf, 11"
set output 'iops-measurement_1280.png'
set key box
set key below
set grid
set xtics
set ytics (100,200,1000,2000,4000,6000,8000,10000,15000,20000,30000,35000,60000,100000)
set title "IOPS Measurement Plot – 2D"
set xlabel 'Block size, KiB'
set xtics ("0.5" 0, "4" 1, "8" 2, "16" 3, "32" 4, "64" 5, "128" 6, "1024" 7)
set ylabel 'IOPS'
#set yrange [100:60000]
set logscale y
plot 'means.csv' using 1:4 every ::49::56 title '0/100' with lp, \
'means.csv' using 1:4 every ::41::48 title '5/95' with lp, \
'means.csv' using 1:4 every ::33::40 title '35/65' with lp, \
'means.csv' using 1:4 every ::25::32 title '50/50' with lp, \
'means.csv' using 1:4 every ::17::24 title '65/35' with lp, \
'means.csv' using 1:4 every ::9::16 title '95/5' with lp, \
'means.csv' using 1:4 every ::1::8 title '100/0' with lp
exit
