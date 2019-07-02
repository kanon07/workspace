#$1=directory 0606, 0705
#$2=number
num=`echo $1 | awk -F '/' '{print $3}'`
bbrdir=${1}/${num}_Sender1
cubicdir=${1}/${num}_Sender2
queuedir=${1}/${num}_queue
mkdir -p /media/sf_graphdeta/$1
deta=/media/sf_graphdeta/$1

if [ -d $bbrdir -a -d $cubicdir ]; then
    echo "co-existing"
    expmode=2
else
    if [ -d $bbrdir ]; then
        echo "only sender1"
        expmode=0

    elif [ -d $cubicdir ]; then
        echo "only sender2"
        expmode=1
    fi
fi

case "$expmode" in
    "0" )
    bbr=`find ${bbrdir} -name *port*.txt`
    bbrtime=`find ${bbrdir} -name time.txt`
    bbrth=`find ${bbrdir} -name *bbr*iperf*.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    paste -d " " $bbrtime $bbr > $bbrdir/time_kernel.txt
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt
    echo $bbr $bbrtime
    echo $queue $queuetime ;;

    "1" )
    cubic=`find ${cubicdir} -name *port*.txt`
    cubictime=`find ${cubicdir} -name time.txt`
    cubicth=`find ${cubicdir} -name *cubic*iperf*.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    paste -d " " $cubictime $cubic > $cubicdir/time_kernel.txt
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt
    echo $cubic $cubictime
    echo $queue $queuetime ;;

    "2" )
    bbr=`find ${bbrdir} -name *port*.txt`
    bbrtime=`find ${bbrdir} -name time.txt`
    bbrth=`find ${bbrdir} -name *bbr*iperf*.txt`
    cubic=`find ${cubicdir} -name *port*.txt`
    cubictime=`find ${cubicdir} -name time.txt`
    cubicth=`find ${cubicdir} -name *cubic*iperf*.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    paste -d " " $bbrtime $bbr > $bbrdir/time_kernel.txt
    paste -d " " $cubictime $cubic > $cubicdir/time_kernel.txt
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt
    echo $bbr $bbrtime
    echo $cubic $cubictime
    echo $queue $queuetime ;;

esac


#pngへの出力
co_throughput="set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:2000]; plot '$bbrth' using 0:7 with lines lc 5 title 'TCP BBR'; replot '$cubicth' using 0:7 with lines lc 8 title 'CUBIC TCP'; set terminal png; set out '$deta/throughput.png'; replot"

throughput1="set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:2000]; plot '$bbrth' using 0:7 with lines lc 5 title 'TCP BBR'; set terminal png; set out '$deta/throughput.png'; replot"

throughput2="set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:2000]; plot '$cubicth' using 0:7 with lines lc 8 title 'CUBIC TCP'; set terminal png; set out '$deta/throughput.png'; replot"


co_cwnd="set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$bbrdir/time_kernel.txt' using 1:10 with lines title 'TCP BBR'; replot '$cubicdir/time_kernel.txt' using 1:10 with lines title 'CUBIC TCP'; set terminal png; set out '$deta/cwnd.png'; replot"

cwnd1="set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$bbrdir/time_kernel.txt' using 1:10 with lines title 'TCP BBR'; set terminal png; set out '$deta/cwnd.png'; replot"

cwnd2="set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$cubicdir/time_kernel.txt' using 1:10 with lines title 'CUBIC TCP'; set terminal png; set out '$deta/cwnd.png'; replot"

btl_rtprop="set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw'; plot '$bbrdir/time_kernel.txt' using 1:12 with lines lc 3 title 'Btlbw'; set y2tics; set y2label 'RTprop [us]'; replot '$bbrdir/time_kernel.txt' using 1:14  axis x1y2 with lines lc 4 title 'RTprop'; set terminal png; set out '$deta/btl_rtprop.png'; replot"

queue="set grid; set xlabel 'Time [s]'; set ylabel 'Queuelength [packets]'; plot '$queuedir/time_kernel.txt' using 1:42 with lines lc 6 title 'queue'; set terminal png; set out '$deta/queue.png'; replot"

srtt="set grid; set xlabel 'Time [s]'; set ylabel 'RTT [us]'; plot '$bbrdir/time_kernel.txt' using 1:24 with lines lc 7 title 'sRTT'; set terminal png; set out '$deta/srtt.png'; replot"

delirate="set grid; set xlabel 'Time [s]'; set ylabel 'deliverd [MB]'; plot '$bbrdir/time_kernel.txt' using 1:28 with lines lc 3 title 'deliverd'; set y2tics; set y2label 'interval [us]'; replot '$bbrdir/time_kernel.txt' using 1:30  axis x1y2 with lines lc 4 title 'interval'; set terminal png; set out '$deta/delirate.png'; replot"


case "$expmode" in
    "0" ) gnuplot -e "$throughput1" & gnuplot -e "$cwnd1" & gnuplot -e "$btl_rtprop" & gnuplot -e "$queue" & gnuplot -e "$srtt" & gnuplot -e "$delirate" ;;
    "1" ) gnuplot -e "$throughput2" & gnuplot -e "$cwnd2" & gnuplot -e "$queue" ;;
    "2" ) gnuplot -e "$co_throughput" & gnuplot -e "$co_cwnd" & gnuplot -e  "$btl_rtprop" & gnuplot -e "$queue" & gnuplot -e "$srtt" & gnuplot -e  "$delirate" ;;
esac


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


