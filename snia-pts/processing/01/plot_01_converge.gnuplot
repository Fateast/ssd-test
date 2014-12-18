#!/usr/bin/gnuplot
set terminal pngcairo size 1280, 1024 enhanced font "/usr/share/fonts/LiberationMono-Regular.ttf, 11"
set output 'iops-steady_state_convergence_range_1280.png'

set linetype 1 lw 2 lc rgb "#B20000"
set linetype 2 lw 2 lc rgb "#00B233"
set linetype 3 lw 2
set linetype 4 lw 2
set linetype 5 lw 2
set linetype 6 lw 2
set linetype 7 lw 2
set linetype 8 lw 2
set style line 11 lc rgb '#808080' lt 1

set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12
set key box
set key below

set xtics 1
set ytics 2000
set title "IOPS Steady State Convergence Plot - All block sizes"
set xlabel 'Round'
set ylabel 'IOPS'
#set xrange [9:15]
plot 'test01_data_ss_detect_512.csv' using 1:4 every ::1 title '0.5KiB' with lp, \
'test01_data_ss_detect_4096.csv' using 1:4 every ::1 title '4KiB' with lp, \
'test01_data_ss_detect_8192.csv' using 1:4 every ::1 title '8KiB' with lp, \
'test01_data_ss_detect_16384.csv' using 1:4 every ::1 title '16KiB' with lp, \
'test01_data_ss_detect_32768.csv' using 1:4 every ::1 title '32KiB' with lp, \
'test01_data_ss_detect_65536.csv' using 1:4 every ::1 title '64KiB' with lp, \
'test01_data_ss_detect_131072.csv' using 1:4 every ::1 title '128KiB' with lp, \
'test01_data_ss_detect_1048576.csv' using 1:4 every ::1 title '1024KiB' with lp
exit
