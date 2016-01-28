#!/usr/bin/gnuplot

set terminal pngcairo size 800, 600 enhanced font "/usr/share/fonts/verdana.ttf, 9" 
set output 'iops-wsat_800.png'

#set obj 1 rectangle behind from screen 0,0 to screen 1,1
#set obj 1 fillstyle solid 1.0 fillcolor rgbcolor "#F0F0F0"

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
#set ytics 2000
#set yrange [10000:22000]
set title "Write saturation test (random write 4K): IOPS"
set xlabel 'Time (minutes)'
set ylabel 'IOPS'
plot 'PTS_04 data.dat' using 1:2 every ::1 title 'Toshiba PX02SM 200GB' with lines
exit
