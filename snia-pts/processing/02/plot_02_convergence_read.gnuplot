#!/usr/bin/gnuplot
set terminal pngcairo size 1280, 1024 enhanced font "/usr/share/fonts/LiberationMono-Regular.ttf, 11"
set output 'read_bw-steady_state_convergence_1280.png'

set linetype 1 lw 2 lc rgb "#B20000"
set linetype 2 lw 2 lc rgb "#00B233"
set linetype 3 lw 2 lc rgb "#0000B2"
set linetype 4 lw 2 lc rgb "#B29200"
set linetype 5 lw 2 lc rgb "#8400B2"
set linetype 6 lw 2 lc rgb "#79B200"
set linetype 7 lw 2 lc rgb "#00B2B2"
set style line 11 lc rgb '#808080' lt 1

set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set key box
set key below
set grid ytics
set xtics 1
set ytics 5
set title "Read bandwidth Steady State Convergence Plot - 1024KiB block size"
set xlabel 'Round'
set ylabel 'Bandwidth (MiB/s)'
set xrange [1:10]
#set yrange [0:600]
plot 'test02_data_read_1m.csv' using 1:($2/1024) title 'Read 1024KiB' with lp
exit
