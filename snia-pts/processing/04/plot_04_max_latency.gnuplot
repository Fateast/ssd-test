#!/usr/bin/gnuplot

set terminal pngcairo  size 800, 600 enhanced font "/usr/share/fonts/verdana.ttf, 9"
set output 'max_lat-wsat_800.png'

set linetype 1 lw 1 lc rgb "#B20000"
set linetype 2 lw 1 lc rgb "#00B233"
set linetype 3 lw 1 lc rgb "#0000B2"
set linetype 4 lw 1 lc rgb "#B29200"
set linetype 5 lw 1 lc rgb "#8400B2"
set linetype 6 lw 1 lc rgb "#79B200"
set linetype 7 lw 1 lc rgb "#00B2B2"

set style line 11 lc rgb '#808080' lt 1

set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12
set key box
set key below

set xtics 30
#set ytics 1
set yrange [1:30]
set logscale y
set title "Write saturation test (random write 4K): Latency"
set xlabel 'Time (minutes)'
set ylabel 'Latency, ms'
plot 'PTS_04 data.dat' using 1:($4/1000) every ::1 title 'Maximum' with lines, \
'PTS_04 data.dat' using 1:($3/1000) every ::1 title 'Mean' with lines, \
'PTS_04 data.dat' using 1:($6/1000) every ::1 title '99 percentile' with lines, \
'PTS_04 data.dat' using 1:($7/1000) every ::1 title '99.9 percentile' with lines, \
'PTS_04 data.dat' using 1:($8/1000) every ::1 title '99.99 percentile' with lines
exit
