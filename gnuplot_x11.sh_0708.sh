#$1=directory 0606, 0705

#range="[10:22] [0:]"
#range="[10:30] [0:]"
#range="[15:17] [0:]"

plotype=0
if [ $2 = "-p" ]; then
    plotype=$3
fi

num=`echo $1 | awk -F '/' '{print $NF}'`
sender1dir=${1}/${num}_Sender1
sender2dir=${1}/${num}_Sender2
queuedir=${1}/${num}_queue
mkdir -p /media/sf_graphdeta/$1/
deta=/media/sf_graphdeta/$1/

if [ -d $sender1dir -a -d $sender2dir ]; then
    echo "co-existing"
    expmode=2
else
    if [ -d $sender1dir ]; then
        echo "only sender1"
        expmode=0

    elif [ -d $sender2dir ]; then
        echo "only sender2"
        expmode=1
    fi
fi

case "$expmode" in
    "0" )
    kernel1=`find ${sender1dir} -name *port*.txt`
    #kernel1=`find ${sender1dir} -name type0.txt`
    time1=`find ${sender1dir} -name time.txt`
    th1=`find ${sender1dir} -name *iperf*.txt`
    btl1=`find ${sender1dir} -name BTLBW.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    ping=`find $1 -name *ping*`
    paste -d " " $time1 $kernel1 > $sender1dir/time_kernel.txt &
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt &
    paste -d " " $time1 $btl1 > $sender1dir/time_btl.txt &
    echo $kernel1 $time1
    echo $queue $queuetime ;;

    "1" )
    kernel2=`find ${sender2dir} -name *port*.txt`
    kernel2=`find ${sender2dir} -name type0.txt`
    time2=`find ${sender2dir} -name time.txt`
    th2=`find ${sender2dir} -name *iperf*.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    paste -d " " $time2 $kernel2 > $sender2dir/time_kernel.txt &
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt &
    echo $kernel2 $time2
    echo $queue $queuetime ;;

    "2" )
    kernel1=`find ${sender1dir} -name *port*.txt`
    #kernel1=`find ${sender1dir} -name type0.txt`
    time1=`find ${sender1dir} -name time.txt`
    th1=`find ${sender1dir} -name *iperf*.txt`
    btl1=`find ${sender1dir} -name BTLBW.txt`
    kernel2=`find ${sender2dir} -name *port*.txt`
    time2=`find ${sender2dir} -name time.txt`
    th2=`find ${sender2dir} -name *iperf*.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    paste -d " " $time1 $kernel1 > $sender1dir/time_kernel.txt &
    paste -d " " $time2 $kernel2 > $sender2dir/time_kernel.txt &
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt &
    paste -d " " $time1 $btl1 > $sender1dir/time_btl.txt &
    echo $kernel1 $time1
    echo $kernel2 $time2
    echo $queue $queuetime ;;
esac

echo $th1

#x11で出力
size="600,400"
thposi="680,0"
cwposi="0,0"
btrtposi="1300,0"
queposi="0,600"
srtposi="1300,600"
deliposi="680,600"


co_throughput="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; replot '$th2' using 0:7 with lines lc 4 title 'CUBIC TCP'; reset"

#throughput, cycle
#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; set y2tics; set y2label 'cycle_idx'; replot '$sender1dir/time_kernel.txt' using 1:20 axis x1y2 with lines title 'cycle_idx';reset"

#pacinggain, cycle_idx
#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'pacing'; plot '$sender1dir/time_kernel.txt' using 1:18 with lines lc 3 title 'pacing_gain'; set y2tics; set y2label 'cycle_idx'; replot '$sender1dir/time_kernel.txt' using 1:20 axis x1y2 with lines title 'cycle';reset"

throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; reset"
#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; set y2tics; set y2label 'ping [ms]'; replot '$ping' using 1:12 axis x1y2 with lines title 'ping';reset"
#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'time [s]';  set ylabel 'ping [ms]'; plot '$ping' using 1:12 with lines title 'ping';reset"

throughput2="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot '$th2' using 0:7 with lines lc 4 title 'CUBIC TCP'; reset"


co_cwnd="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$sender1dir/time_kernel.txt' using 1:10 with lines lc 3 title 'TCP BBR'; replot '$sender2dir/time_kernel.txt' using 1:10 with lines lc 4 title 'CUBIC TCP'; reset"

#cwndをtarget_cwndからとっている
#cwnd1="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$sender1dir/time_kernel.txt' using 1:10 with lines lc 3 title 'TCP BBR'; reset"

#cwndをtpからとっている
cwnd1="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot $range '$sender1dir/time_kernel.txt' using 1:28 with lines lc 3 title 'TCP BBR'; reset"

cwnd2="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$sender2dir/time_kernel.txt' using 1:10 with lines lc 4 title 'CUBIC TCP'; reset"

#btl_rtprop="set terminal x11 3 title 'Btlbw, RTprop' size $size position $btrtposi; set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot '$sender1dir/time_btl.txt' using 1:2 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'RTprop [us]'; set y2tics format '%2.1t{/Symbol \264}10^{%L}'; replot '$sender1dir/time_kernel.txt' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; reset"
btl_rtprop="set terminal x11 3 title 'Btlbw, RTprop' size $size position $btrtposi; set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$sender1dir/time_btl.txt' using 1:2 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'RTprop [ms]'; replot '$sender1dir/time_kernel.txt' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; reset"

queue="set terminal x11 4 title 'Queue' size 600,400 position $queposi; set grid; set xlabel 'Time [s]'; set ylabel 'Queuelength [packets]'; plot $range '$queuedir/time_kernel.txt' using 1:42 with lines lc 6 title 'queue'; reset"

#単位がus, kernelmoniter上で変更済み
#srtt="set terminal x11 5 title 'sRTT' size $size position $srtposi; set grid; set xlabel 'Time [s]'; set ylabel 'RTT [us]'; set ytics format '%2.1t{/Symbol \264}10^{%L}'; plot '$sender1dir/time_kernel.txt' using 1:26 with lines lc 7 title 'sRTT'; reset"
#modeを追加
#srtt="set terminal x11 5 title 'sRTT' size $size position $srtposi; set grid; set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot '$sender1dir/time_kernel.txt' using 1:26 with lines lc 7 title 'sRTT'; reset"
srtt="set terminal x11 5 title 'sRTT, mode' size $size position $srtposi; set grid; set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot $range '$sender1dir/time_kernel.txt' using 1:26 with lines lc 7 title 'sRTT'; set y2tics; set y2label 'mode'; set y2range [0:3]; replot '$sender1dir/time_kernel.txt' using 1:16 axis x1y2 with linespoints title 'mode'; reset"

delirate="set terminal x11 6 title 'deliverd, interval' size $size position $deliposi; set grid; set xlabel 'Time [s]'; set ylabel 'deliverd [packets]'; plot $range '$sender1dir/time_kernel.txt' using 1:30 with lines lc 3 title 'deliverd'; set y2tics; set y2label 'interval [ms]'; replot '$sender1dir/time_kernel.txt' using 1:32  axis x1y2 with lines lc 4 title 'interval'; reset"
#delirate="set terminal x11 6 title 'deliverd, interval' size $size position $deliposi; set grid; set xlabel 'Time [s]'; set ylabel 'deliverd [packets]'; plot $range '$sender1dir/time_kernel.txt' using 1:30 with lines lc 3 title 'deliverd'; set y2tics; set y2label 'interval [us]'; set ytics format '%2.1t{/Symbol \264}10^{%L}'; set y2tics format '%2.1t{/Symbol \264}10^{%L}'; replot '$sender1dir/time_kernel.txt' using 1:32  axis x1y2 with lines lc 4 title 'interval'; reset"
#delirate="set terminal x11 6 title 'deliverd, interval' size $size position $deliposi; set grid; set xlabel 'Time [s]'; set ylabel 'deliverd [MB]'; plot '$sender1dir/time_kernel.txt' using 1:30 with lines lc 3 title 'deliverd'; set y2tics; set y2label 'interval [us]'; set ytics format '%2.1t{/Symbol \264}10^{%L}'; set y2tics format '%2.1t{/Symbol \264}10^{%L}'; replot '$sender1dir/time_kernel.txt' using 1:32  axis x1y2 with lines lc 4 title 'interval'; reset"

case "$plotype" in
    #"t" ) gnuplot -e " $co_throughput ; pause -1" ;;
    "t" ) gnuplot -e " $throughput1 ; pause -1" ;;
    "c" ) gnuplot -e " $co_cwnd ; pause -1" ;;
    "b" ) gnuplot -e " $btl_rtprop ; pause -1" ;;
    "s" ) gnuplot -e " $srtt ; pause -1" ;;
    "d" ) gnuplot -e " $delirate ; pause -1" ;;
esac


case "$expmode" in
    #"0" ) gnuplot -e " $throughput1 ; $cwnd1 ; $btl_rtprop ; $queue ; $srtt ; $delirate ; pause -1" ;;
    "0" ) gnuplot -e " $throughput1 ; $cwnd1 ; $btl_rtprop ; $srtt ; $delirate ; $queue ; pause -1" ;;
    "1" ) gnuplot -e " $throughput2 ; $cwnd2 ; $queue ; pause -1" ;;
    "2" ) gnuplot -e " $co_throughput ; $co_cwnd ; $btl_rtprop ; $queue ; $srtt ; $delirate ; pause -1" ;;
esac


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
#26 = srtt_us= 44897
#26 = snd_cwnd= 488
#28 = deliverd
#30 = interval

