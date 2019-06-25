#$1=directory 0606, 0705
#$2=number

bbrdir=${1}/number${2}/number${2}_Sender1
cubicdir=${1}/number${2}/number${2}_Sender2
queuedir=${1}/number${2}/number${2}_queue

bbr=`find ${bbrdir} -name *port*.txt`
bbrtime=`find ${bbrdir} -name time.txt`
bbrth=`find ${bbrdir} -name bbr*iperf*`
cubic=`find ${cubicdir} -name *port*.txt`
cubictime=`find ${cubicdir} -name time.txt`
cubicth=`find ${cubicdir} -name cubic*iperf*`
queue=`find ${queuedir} -name *moni*`
queuetime=`find ${queuedir} -name time.txt`
paste -d " " $bbrtime $bbr > $bbrdir/time_kernel.txt
paste -d " " $cubictime $cubic > $cubicdir/time_kernel.txt
paste -d " " $queuetime $queue > $queuedir/time_kernel.txt
echo $bbr $bbrtime
echo $cubic $cubictime
echo $queue $queuetime

mkdir -p /media/sf_graphdeta/$1/number${2}
deta=/media/sf_graphdeta/$1/number${2}


#pngへの出力

gnuplot -e "set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:2000]; plot '$bbrth' using 0:7 with lines title 'TCP BBR'; replot '$cubicth' using 0:7 with lines title 'CUBIC TCP'; set terminal png; set out '$deta/throughput.png'; replot" &

gnuplot -e "set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$bbrdir/time_kernel.txt' using 1:10 with lines title 'TCP BBR'; replot '$cubicdir/time_kernel.txt' using 1:10 with lines title 'CUBIC TCP'; set terminal png; set out '$deta/cwnd.png'; replot" &

gnuplot -e "set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw'; plot '$bbrdir/time_kernel.txt' using 1:12 with lines lc 3 title 'Btlbw'; set y2tics; set y2label 'RTprop [us]'; replot '$bbrdir/time_kernel.txt' using 1:14  axis x1y2 with lines lc 4 title 'RTprop'; set terminal png; set out '$deta/btlbw_rtprop.png'; replot" &

gnuplot -e "set grid; set xlabel 'Time [s]'; set ylabel 'Queue'; plot '$queuedir/time_kernel.txt' using 1:42 with lines lc 6 title 'Queue'; set terminal png; set out '$deta/queue.png'; replot" &

gnuplot -e "set grid; set xlabel 'Time [s]'; set ylabel 'sRTT'; plot '$bbrdir/time_kernel.txt' using 1:24 with lines lc 7 title 'sRTT'; set terminal png; set out '$deta/srtt.png'; replot" &

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


