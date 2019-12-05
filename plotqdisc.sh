#x11で出力

dir=$1/timecheckqdisc.txt
size="600,400"
thposi="680,0"
cwposi="0,0"
btrtposi="1300,0"
queposi="0,600"
srtposi="1300,600"
deliposi="680,600"

#qdisc="set terminal x11 1 title 'qdisc' ; set grid; set xlabel 'Time [s]'; set ylabel 'qdisc [ms]'; set yrange [0:1200]; plot '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; reset"
#qdisc="set terminal x11 1 title 'qdisc' ; set grid; set xlabel 'Time [s]'; set ylabel 'qdisc [ms]'; plot '$1/autoqdisc.txt' using 1:14 with lines lc 3 ; reset"
qdisc="set terminal x11 1 title 'qdisc' ; set grid; set xlabel 'Time [s]'; set ylabel 'qdisc [ms]'; plot '$dir' using 1:14 with lines lc 3 ; set y2tics; set y2label 'check'  ; replot '$dir2' using 1:15 axis x1y2 with lines lc 4 ; reset"

gnuplot -e " $qdisc ; pause -1"


#display $1/number${2}_cwnd.png
#display $1/number${2}_btlbw_rtprop.png


#using
#10 = cwnd4= 488
#12 = btlbw= 1423700
#14 = rtprop= 2076
#16 = mode= 2
#18 = pacing_gain= 256
#20 = sport= 48106
#22 = dport= 5000
#24 = srtt_us= 44897
#26 = snd_cwnd= 488
#28 = deliverd
#30 = interval

