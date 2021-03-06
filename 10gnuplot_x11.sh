#$1=directory 0606, 0705

range="[0:] [0:]"
#rttrange="[0:20] [0:10]"
rttrange="[0:40] [0:120]"
rtty2range="set y2range [0:100];"
#range="[14:18] [0:]"
#range="[10:22] [0:]"
#range="[30:40] [0:]"
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
    #kernel1=`find ${sender1dir} -name *port*.txt`
    kernel1=`find ${sender1dir} -name time_type0.txt`
    #time1=`find ${sender1dir} -name time.txt`
    th1=`find ${sender1dir} -name sender1_iperf_30.txt`
    th11=`find ${sender1dir} -name sender1_iperf_31.txt`
    th3=`find ${sender1dir} -name sender1_iperf_32.txt`
    th4=`find ${sender1dir} -name sender1_iperf_33.txt`
    th5=`find ${sender1dir} -name sender1_iperf_34.txt`
    th6=`find ${sender1dir} -name sender1_iperf_35.txt`
    th7=`find ${sender1dir} -name sender1_iperf_36.txt`
    th8=`find ${sender1dir} -name sender1_iperf_37.txt`
    th9=`find ${sender1dir} -name sender1_iperf_38.txt`
    th10=`find ${sender1dir} -name sender1_iperf_39.txt`
    #btl1=`find ${sender1dir} -name BTLBW.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    ping=`find $1 -name *ping*`
    #paste -d " " $time1 $kernel1 > $sender1dir/time_kernel.txt &
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt &
    #paste -d " " $time1 $btl1 > $sender1dir/time_btl.txt &
    echo $kernel1
    echo $queue $queuetime ;;

    "1" )
    #kernel2=`find ${sender2dir} -name *port*.txt`
    kernel2=`find ${sender2dir} -name type0.txt`
    time2=`find ${sender2dir} -name time.txt`
    th2=`find ${sender2dir} -name sender2_iperf*.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    paste -d " " $time2 $kernel2 > $sender2dir/time_kernel.txt &
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt &
    echo $kernel2 $time2
    echo $queue $queuetime ;;

    "2" )
    #kernel1=`find ${sender1dir} -name *port*.txt`
    kernel1=`find ${sender1dir} -name time_type0.txt`
    #time1=`find ${sender1dir} -name time.txt`
    th1=`find ${sender1dir} -name sender1_iperf_30.txt`
    th11=`find ${sender1dir} -name sender1_iperf_31.txt`
    th3=`find ${sender1dir} -name sender1_iperf_32.txt`
    th4=`find ${sender1dir} -name sender1_iperf_33.txt`
    th5=`find ${sender1dir} -name sender1_iperf_34.txt`
    th6=`find ${sender1dir} -name sender1_iperf_35.txt`
    th7=`find ${sender1dir} -name sender1_iperf_36.txt`
    th8=`find ${sender1dir} -name sender1_iperf_37.txt`
    th9=`find ${sender1dir} -name sender1_iperf_38.txt`
    th10=`find ${sender1dir} -name sender1_iperf_39.txt`
    #btl1=`find ${sender1dir} -name BTLBW.txt`
    kernel2=`find ${sender2dir} -name *port*.txt`
    time2=`find ${sender2dir} -name time.txt`
    th2=`find ${sender2dir} -name sender2_iperf_30.txt`
    th12=`find ${sender2dir} -name sender2_iperf_31.txt`
    th13=`find ${sender2dir} -name sender2_iperf_32.txt`
    th14=`find ${sender2dir} -name sender2_iperf_33.txt`
    th15=`find ${sender2dir} -name sender2_iperf_34.txt`
    th16=`find ${sender2dir} -name sender2_iperf_35.txt`
    th17=`find ${sender2dir} -name sender2_iperf_36.txt`
    th18=`find ${sender2dir} -name sender2_iperf_37.txt`
    th19=`find ${sender2dir} -name sender2_iperf_38.txt`
    th20=`find ${sender2dir} -name sender2_iperf_39.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    #paste -d " " $time1 $kernel1 > $sender1dir/time_kernel.txt &
    paste -d " " $time2 $kernel2 > $sender2dir/time_kernel.txt &
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt &
    #paste -d " " $time1 $btl1 > $sender1dir/time_btl.txt &
    echo $kernel1
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

cat ${1}/log.txt

#co_throughput="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; replot '$th2' using 0:7 with lines lc 4 title 'CUBIC TCP'; reset"
co_throughput="set terminal x11 1 title 'BBRThroughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$th1' using 0:7 with lines lc 3 title 'TCP BBR1'; replot '$th11' using 0:7 with lines lc 1 title 'TCP BBR2'; replot '$th3' using 0:7 with lines lc 2 title 'TCP BBR3'; replot '$th4' using 0:7 with lines lc 5 title 'TCP BBR4'; replot '$th5' using 0:7 with lines lc 6 title 'TCP BBR5'; replot '$th6' using 0:7 with lines lc 7 title 'TCP BBR6'; replot '$th7' using 0:7 with lines lc 8 title 'TCP BBR7'; replot '$th8' using 0:7 with lines lc 9 title 'TCP BBR8'; replot '$th9' using 0:7 with lines lc 10 title 'TCP BBR9'; replot '$th10' using 0:7 with lines lc 11 title 'TCP BBR10'; reset"


delirate="set terminal x11 6 title 'CUBICThroughput' size $size position $deliposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$th2' using 0:7 with lines lc 3 title 'CUBIC TCP1'; replot '$th12' using 0:7 with lines lc 4 title 'CUBIC TCP2';  replot '$th13' using 0:7 with lines lc 5 title 'CUBIC TCP3'; replot '$th14' using 0:7 with lines lc 6 title 'CUBIC TCP4'; replot '$th15' using 0:7 with lines lc 7 title 'CUBIC TCP5'; replot '$th16' using 0:7 with lines lc 8 title 'CUBIC TCP6'; replot '$th17' using 0:7 with lines lc 9 title 'CUBIC TCP7'; replot '$th18' using 0:7 with lines lc 10 title 'CUBIC TCP8'; replot '$th19' using 0:7 with lines lc 11 title 'CUBIC TCP9'; replot '$th20' using 0:7 with lines lc 12 title 'CUBIC TCP10'; reset"


#throughput, cycle
#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; set y2tics; set y2label 'cycle_idx'; replot '$kernel1' using 1:20 axis x1y2 with lines title 'cycle_idx';reset"

#pacinggain, cycle_idx
#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'pacing'; plot '$kernel1' using 1:18 with lines lc 3 title 'pacing_gain'; set y2tics; set y2label 'cycle_idx'; replot '$kernel1' using 1:20 axis x1y2 with lines title 'cycle';reset"

#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; reset"
throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$th1' using 0:7 with lines lc 3 title 'TCP BBR1'; replot '$th11' using 0:7 with lines lc 1 title 'TCP BBR2'; replot '$th3' using 0:7 with lines lc 2 title 'TCP BBR3'; replot '$th4' using 0:7 with lines lc 5 title 'TCP BBR4'; replot '$th5' using 0:7 with lines lc 6 title 'TCP BBR5'; replot '$th6' using 0:7 with lines lc 7 title 'TCP BBR6'; replot '$th7' using 0:7 with lines lc 8 title 'TCP BBR7'; replot '$th8' using 0:7 with lines lc 9 title 'TCP BBR8'; replot '$th9' using 0:7 with lines lc 10 title 'TCP BBR9'; replot '$th10' using 0:7 with lines lc 11 title 'TCP BBR10'; reset"
#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot '$th1' using 0:7 with lines lc 3 title 'TCP BBR'; set y2tics; set y2label 'ping [ms]'; replot '$ping' using 1:12 axis x1y2 with lines title 'ping';reset"
#throughput1="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'time [s]';  set ylabel 'ping [ms]'; plot '$ping' using 1:12 with lines title 'ping';reset"

throughput2="set terminal x11 1 title 'Throughput' size $size position $thposi; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot '$th2' using 0:7 with lines lc 4 title 'CUBIC TCP'; reset"


co_cwnd="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$kernel1' using 1:10 with lines lc 3 title 'TCP BBR'; replot '$sender2dir/time_kernel.txt' using 1:10 with lines lc 4 title 'CUBIC TCP'; reset"

#cwndをtarget_cwndからとっている
#cwnd1="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$kernel1' using 1:10 with lines lc 3 title 'TCP BBR'; reset"

#cwndをtpからとっている
#cwnd1="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot $range '$kernel1' using 1:28 with lines lc 3 title 'TCP BBR'; reset"
cwnd1="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot $range '$kernel1' using 1:28 with lines lc 3 title 'TCP BBR'; reset"

cwnd2="set terminal x11 2 title 'Cwnd' size $size position $cwposi; set grid; set xlabel 'Time [s]'; set ylabel 'Congestion window size [segment]'; plot '$sender2dir/time_kernel.txt' using 1:10 with lines lc 4 title 'CUBIC TCP'; reset"

#btl_rtprop="set terminal x11 3 title 'Btlbw, RTprop' size $size position $btrtposi; set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot '$sender1dir/time_btl.txt' using 1:2 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'RTprop [us]'; set y2tics format '%2.1t{/Symbol \264}10^{%L}'; replot '$kernel1' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; reset"
#btl_rtprop="set terminal x11 3 title 'Btlbw, RTprop' size $size position $btrtposi; set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$kernel1' using 1:12 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'RTprop [ms]'; replot '$kernel1' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; reset"
#btl_rtprop="set terminal x11 3 title 'Btlbw, RTprop' size $size position $btrtposi; set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$kernel1' using 1:12 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'mode'; y2range [0:3]; replot '$kernel1' using 1:16  axis x1y2 with linespoints title 'mode'; reset"
btl_rtprop="set terminal x11 3 title 'Btlbw, RTprop' size $size position $btrtposi; set grid; set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$kernel1' using 1:12 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'mode'; replot '$kernel1' using 1:16  axis x1y2 with linespoints title 'mode'; reset"

queue="set terminal x11 4 title 'Queue' size 600,400 position $queposi; set grid; set xlabel 'Time [s]'; set ylabel 'Queuelength [packets]'; plot $range '$queuedir/time_kernel.txt' using 1:42 with lines lc 6 title 'queue'; reset"

#単位がus, kernelmoniter上で変更済み
#srtt="set terminal x11 5 title 'sRTT' size $size position $srtposi; set grid; set xlabel 'Time [s]'; set ylabel 'RTT [us]'; set ytics format '%2.1t{/Symbol \264}10^{%L}'; plot '$kernel1' using 1:26 with lines lc 7 title 'sRTT'; reset"
#modeを追加
#srtt="set terminal x11 5 title 'sRTT' size $size position $srtposi; set grid; set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot '$kernel1' using 1:26 with lines lc 7 title 'sRTT'; reset"
#srtt="set terminal x11 5 title 'sRTT, mode' size $size position $srtposi; set grid; set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot $range '$kernel1' using 1:38 with lines lc 7 title 'sRTT'; set y2tics; set y2label 'mode'; set y2range [0:3]; replot '$kernel1' using 1:16 axis x1y2 with linespoints title 'mode'; reset"
#srtt="set terminal x11 5 title 'sRTT, mode' size $size position $srtposi; set grid; set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot $range '$kernel1' using 1:(\$38/1000.0) with lines lc 7 title 'sRTT' ; replot '$kernel1' using 1:14 axis x1y2 with linespoints title 'RTprop'; reset"
srtt="set terminal x11 5 title 'RTT, mode' size $size position $srtposi; set grid; set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot $rttrange $range '$kernel1' using 1:(\$26/1000.0) with lines lc 7 title 'RTT' ; replot '$kernel1' using 1:(\$14/1000.0) with linespoints title 'RTprop'; set y2tics;  $rtty2range set y2label 'RTT/RTprop';replot '$kernel1' using 1:(\$26/\$14) axis x1y2 with lines title 'RTT/RTprop'; reset"

#delirate="set terminal x11 6 title 'deliverd, interval' size $size position $deliposi; set grid; set xlabel 'Time [s]'; set ylabel 'deliverd [packets]'; plot $range '$kernel1' using 1:30 with lines lc 3 title 'deliverd'; set y2tics; set y2label 'interval [us]'; replot '$kernel1' using 1:36  axis x1y2 with lines lc 4 title 'interval'; reset"
#delirate="set terminal x11 6 title 'deliverd, interval' size $size position $deliposi; set grid; set xlabel 'Time [s]'; set ylabel 'deliverd [packets]'; plot $range '$kernel1' using 1:30 with lines lc 3 title 'deliverd'; set y2tics; set y2label 'interval [us]'; set ytics format '%2.1t{/Symbol \264}10^{%L}'; set y2tics format '%2.1t{/Symbol \264}10^{%L}'; replot '$kernel1' using 1:32  axis x1y2 with lines lc 4 title 'interval'; reset"
#delirate="set terminal x11 6 title 'deliverd, interval' size $size position $deliposi; set grid; set xlabel 'Time [s]'; set ylabel 'deliverd [MB]'; plot '$kernel1' using 1:30 with lines lc 3 title 'deliverd'; set y2tics; set y2label 'interval [us]'; set ytics format '%2.1t{/Symbol \264}10^{%L}'; set y2tics format '%2.1t{/Symbol \264}10^{%L}'; replot '$kernel1' using 1:32  axis x1y2 with lines lc 4 title 'interval'; reset"

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
#20 = lt_use
#22 = sport= 48106
#24 = dport= 5000
#26 = rs_rtt_us= 44897
#28 = snd_cwnd= 488
#30 = deliverd
#32 = interval
#34 = prev_interval
#36 = canon_interval
#38 = tp->srttus

