#!/usr/bin/gnuplot

set terminal pngcairo size 800, 600 enhanced font "/usr/share/fonts/verdana.ttf, 9"
set output 'lat-wsat_800.png'

set linetype 1 lw 2 lc rgb "#B20000"
set linetype 2 lw 2 lc rgb "#00B233"
set style line 11 lc rgb '#808080' lt 1

set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12
set key box
set key below

set xtics 30
#set ytics 0.5
set yrange [2:]
set title "Write saturation test (random write 4K): Average latency"
set xlabel 'Time (minutes)'
set ylabel 'Latency, ms'
plot 'PTS_04 data.dat' using 1:($3/1000) every ::1 title 'Toshiba PX02SM 200GB' with lines
exit
