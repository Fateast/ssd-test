#!/usr/bin/gnuplot
set terminal pngcairo size 1280, 1024 enhanced font "/usr/share/fonts/LiberationMono-Regular.ttf, 11"
set output 'throughtput-steady_state_verification_1280.png'
set linetype 1 lw 2 lc rgb "#B20000"
set linetype 3 lw 2 lc rgb "#00B233"
set linetype 5 lc rgb "black" lw 2
set style line 11 lc rgb '#808080' lt 1

set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12
set key box
set key below

set grid ytics
set xtics 1
set title "Steady State Verification"
set xlabel 'Round'
set ylabel 'Bandwidth (MiB/s)'
set xrange [5:11]
#set yrange [40000:42000]
f(x) = m*x + b
fit [6:10] f(x) 'test02_data_write_1m.csv' using 1:($2/1024) every ::6::10 via m,b
stats 'test02_data_write_1m.csv' using ($2/1024) every ::6::10 prefix "A"
plot 'test02_data_write_1m.csv' using 1:($2/1024) every ::6::10 lt 1 notitle with points, \
'test02_data_write_1m.csv' using 1:($2/1024) every ::6::10 lt 1 title 'Data' smooth csplines with lines, \
m*x+b title 'Slope', \
A_mean title 'Average', \
A_mean*1.1 title '110%*Average' lt 5, \
A_mean*0.9 title '90%*Average' lt 5
set print "plot_ss_verify.log"
print A_mean, A_min, A_max, m, b
exit
