#!/usr/bin/gnuplot

set terminal pngcairo size 800, 600 enhanced font "/usr/share/fonts/verdana.ttf, 9"
set output 'HIR_lat_800.png'

set linetype 1 lw 1 lc rgb "#B20000"
set linetype 2 lw 1 lc rgb "#00B233"
set linetype 3 lw 1 lc rgb "#0000B2"
set linetype 4 lw 1 lc rgb "#B29200"
set linetype 5 lw 1 lc rgb "#8400B2"
set linetype 6 lw 1 lc rgb "#79B200"
set linetype 7 lw 1 lc rgb "#00B2B2"
set linetype 8 lw 1 lc rgb "#000000"

set style line 11 lc rgb '#808080' lt 1

set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set key box
set key below

#set xtics 30
#set ytics 2000
set xrange [0:930]
set yrange [5.5:35]
set title "HIR average latency vs time"
set xlabel 'Time (minutes)'
set ylabel 'Latency, ms'
plot 'test05_data.csv' using ($1*10/60):($3/1000) every ::1::360 title 'State 1 AB' with lines, \
'test05_data.csv' using ($1*5/60+60):($3/1000) every ::361::720 title 'State 1 C' with lines lt 8, \
'test05_data.csv' using ($1*15/60+60+30):($3/1000) every ::721::1080 title 'State 2 AB' with lines, \
'test05_data.csv' using ($1*5/60+60+30+90):($3/1000) every ::1081::1440 title 'State 2 C' with lines lt 8, \
'test05_data.csv' using ($1*20/60+60+30+90+30):($3/1000) every ::1441::1800 title 'State 3 AB' with lines, \
'test05_data.csv' using ($1*5/60+60+30+90+30+120):($3/1000) every ::1801::2160 title 'State 3 C' with lines lt 8, \
'test05_data.csv' using ($1*30/60+60+30+90+30+120+30):($3/1000) every ::2161::2520 title 'State 5 AB' with lines, \
'test05_data.csv' using ($1*5/60+60+30+90+30+120+30+180):($3/1000) every ::2521::2880 title 'State 5 C' with lines lt 8, \
'test05_data.csv' using ($1*55/60+60+30+90+30+120+30+180+30):($3/1000) every ::2881::3240 title 'State 10 AB' with lines, \
'test05_data.csv' using ($1*5/60+60+30+90+30+120+30+180+30+330):($3/1000) every ::3241::3600 title 'State 10 C' with lines lt 8
exit
