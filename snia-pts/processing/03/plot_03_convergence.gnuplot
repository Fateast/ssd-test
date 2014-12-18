#!/usr/bin/gnuplot
set terminal png size 1280, 1024 font "/usr/share/fonts/LiberationMono-Regular.ttf, 11"
set output 'latency-steady_state_convergence_1280.png'
set key box
set key below
set grid ytics
set xtics 1
#set ytics 30
set title "Latency Steady State Convergence Plot"
set xlabel 'Round'
set ylabel 'Latency (microseconds)'
set xrange [1:25]
set yrange [0:]
plot 'test03_data_ss_detect_512.csv' using 1:3 every ::1 title 'RW=0/100, BS=0.5KiB' with lp, \
'test03_data_ss_detect_4096.csv' using 1:3 every ::1 title 'RW=0/100, BS=4KiB' with lp, \
'test03_data_ss_detect_8192.csv' using 1:3 every ::1 title 'RW=0/100, BS=8KiB' with lp
exit
