#!/usr/bin/gnuplot
set terminal png size 1280, 1024 font "/usr/share/fonts/LiberationMono-Regular.ttf, 11"
set output 'latency-steady_state_verification_1280.png'
set linetype 1 lw 2 pt 7
set linetype 3 lw 2 lt 2
set linetype 5 lc rgb "black" lw 2
set key box
set key below
set grid ytics
set xtics 1
set title "Steady State Verification"
set xlabel 'Round'
set ylabel 'Latency (microseconds)'
set xrange [13:19]
#set yrange [40000:42000]
f(x) = m*x + b
fit [14:18] f(x) 'test03_data_ss_detect_4096.csv' using 1:3 every ::14::18 via m,b
stats 'test03_data_ss_detect_4096.csv' using 3 every ::14::18 prefix "A"
plot 'test03_data_ss_detect_4096.csv' using 1:3 every ::14::18 lt 1 notitle with points, \
'test03_data_ss_detect_4096.csv' using 1:3 every ::14::18 lt 1 title 'IOPS' smooth csplines with lines, \
m*x+b title 'Slope', \
A_mean title 'Average', \
A_mean*1.1 title '110%*Average' lt 5, \
A_mean*0.9 title '90%*Average' lt 5
set print "plot_ss_verify.log"
print A_mean, A_min, A_max, m, b
exit
