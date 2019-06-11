#$1=directory 0606, 0705
#$2=number

bbrtemp=${1}/
cubictemp=${1}/
bbrdir=${bbrtemp}number${2}_Sender1
cubicdir=${cubictemp}number${2}_Sender2

bbr=`find ${bbrdir} -name *port*.txt`
bbrtime=`find ${bbrdir} -name time.txt`
cubic=`find ${cubicdir} -name *port*.txt`
cubictime=`find ${cubicdir} -name time.txt`
paste -d " " $bbrtime $bbr > $bbrdir/time_kernel.txt
paste -d " " $cubictime $cubic > $cubicdir/time_kernel.txt
echo $bbr $bbrtime
echo $cubic $cubictime

#pngへの出力
gnuplot -e "set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$bbrdir/time_kernel.txt' using 1:10 with lines title 'TCP BBR'; replot '$cubicdir/time_kernel.txt' using 1:10 with lines title 'CUBIC TCP'; set terminal png; set out '$1/number${2}_cwnd.png'; replot"

gnuplot -e "set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw'; plot '$bbrdir/time_kernel.txt' using 1:12 with lines title 'Btlbw'; set y2tics; set y2label 'RTprop [us]'; replot '$bbrdir/time_kernel.txt' using 1:14  axis x1y2 with lines title 'RTprop'; set terminal png; set out '$1/number${2}_btlbw_rtprop.png'; replot"

#x11で出力
gnuplot -e "set terminal x11 1; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$bbrdir/time_kernel.txt' using 1:10 with lines title 'TCP BBR'; replot '$cubicdir/time_kernel.txt' using 1:10 with lines title 'CUBIC TCP'; set terminal x11 2; set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw'; plot '$bbrdir/time_kernel.txt' using 1:12 with lines title 'Btlbw'; set y2tics; set y2label 'RTprop [us]'; replot '$bbrdir/time_kernel.txt' using 1:14  axis x1y2 with lines title 'RTprop'; pause -1"


#display $1/number${2}_cwnd.png
#display $1/number${2}_btlbw_rtprop.png


#using
#9  = cwnd4= 488
#11 = btlbw= 1423700
#13 = rtprop= 2076 
#15 = mode= 2 
#17 = pacing_gain= 256
#19 = sport= 48106 
#21 = dport= 5000 
#23 = srtt_us= 44897 
#25 = snd_cwnd= 488


