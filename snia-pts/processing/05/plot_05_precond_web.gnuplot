#!/usr/bin/gnuplot

set terminal pngcairo size 800, 600 enhanced font "/usr/share/fonts/verdana.ttf, 9"
set output 'HIR_precond_800.png'

set linetype 1 lw 1 lc rgb "#B20000"
set linetype 2 lw 1 lc rgb "#00B233"
set style line 11 lc rgb '#808080' lt 1

set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12
set key box
set key below

#set xtics 1
#set ytics 2000
#set yrange [0:]
set title "HIR IOPS vs Time"
set xlabel 'Time (minutes)'
set ylabel 'IOPS'
plot 'test05_data_preconditioning.csv' using 1:2 every ::1 title 'Random write 4K' with lines
exit
