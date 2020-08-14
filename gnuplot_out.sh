#$1=directory 0606, 0705
#$2=number
#range="[10:30] [0:]"
range="[0:140] [0:]"
rttrange="[0:140] [0:]"
num=`echo $1 | awk -F '/' '{print $3}'`
bbrdir=${1}/${num}_Sender1
cubicdir=${1}/${num}_Sender2
queuedir=${1}/${num}_queue
mkdir -p /media/sf_graphdeta/$1
deta=/media/sf_graphdeta/$1

#拡張子
#extension1="emf enhanced 'Arial,30'"
extension1=emf
dot_extension1=emf

extension2=png
dot_extension2=png
#png
#emf


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
    bbr=`find ${bbrdir} -name time_type0.txt`
    #bbrtime=`find ${bbrdir} -name time.txt`
    bbrth=`find ${bbrdir} -name sender1_iperf*.txt`
    #bbrbtl=`find ${bbrdir} -name BTLBW.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    #paste -d " " $bbrtime $bbr > $bbrdir/time_kernel.txt
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt
    #paste -d " " $bbrtime $bbrbtl > $bbrdir/time_btl.txt
    echo $bbr $bbrtime
    echo $queue $queuetime ;;

    "1" )
    cubic=`find ${cubicdir} -name type0.txt`
    cubictime=`find ${cubicdir} -name time.txt`
    cubicth=`find ${cubicdir} -name sender2_iperf*.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    paste -d " " $cubictime $cubic > $cubicdir/time_kernel.txt
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt
    echo $cubic $cubictime
    echo $queue $queuetime ;;

    "2" )
    bbr=`find ${bbrdir} -name time_type0.txt`
    #bbrtime=`find ${bbrdir} -name time.txt`
    bbrth=`find ${bbrdir} -name sender1_iperf*.txt`
    #bbrbtl=`find ${bbrdir} -name BTLBW.txt`
    cubic=`find ${cubicdir} -name *port*.txt`
    cubictime=`find ${cubicdir} -name time.txt`
    cubicth=`find ${cubicdir} -name sender2_iperf*.txt`
    queue=`find ${queuedir} -name *moni*`
    queuetime=`find ${queuedir} -name time.txt`
    #paste -d " " $bbrtime $bbr > $bbrdir/time_kernel.txt
    paste -d " " $cubictime $cubic > $cubicdir/time_kernel.txt
    paste -d " " $queuetime $queue > $queuedir/time_kernel.txt
    #paste -d " " $bbrtime $bbrbtl > $bbrdir/time_btl.txt
    echo $bbr
    echo $cubic $cubictime
    echo $queue $queuetime ;;

esac
#グラフサイズ
lmargin="set lmargin at screen 0.15; set ylabel offset -3.2,0;"
rmargin="set rmargin at screen 0.82; set y2label offset 3.5,0;"
#フォントサイズ
#fsize="40"
fsize="24"
xfont="set xlabel font 'Arial,$fsize';"
yfont="set ylabel font 'Arial,$fsize';"
y2font="set y2label font 'Arial,$fsize';"
ticfont="set tics font 'Arial,$fsize';"
keyfont="set key font 'Arial, $fsize';"
fonts=${xfont}${yfont}${y2font}${ticfont}${keyfont}


#$extensionへの出力

#for i in 1 2
 #   do
co_throughput="set grid; set xlabel 'Time [s]'; $lmargin set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$bbrth' using 0:7 with lines lc 3 title 'TCP BBR'; replot '$cubicth' using 0:7 with lines lc 4 title 'CUBIC TCP'; $fonts set terminal $extension1; set out '$deta/throughput.$dot_extension1'; replot"

throughput1="set grid; set xlabel 'Time [s]'; $lmargin set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$bbrth' using 0:7 with lines lc 3 title 'TCP BBR'; $fonts set terminal $extension1 ; set out '$deta/throughput.$dot_extension1'; replot"

throughput2="set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:1200]; plot $range '$cubicth' using 0:7 with lines lc 4 title 'CUBIC TCP'; $fonts set terminal $extension1; set out '$deta/throughput.$dot_extension1'; replot"


co_cwnd="set grid; set xlabel 'Time [s]'; $lmargin  set ylabel 'Congestion window size [segment]'; plot $range '$bbr' using 1:28 with lines lc 3 title 'TCP BBR'; replot '$cubicdir/time_kernel.txt' using 1:10 with lines lc 4 title 'CUBIC TCP'; $fonts set terminal $extension1; set out '$deta/cwnd.$dot_extension1'; replot"

cwnd1="set grid; set xlabel 'Time [s]'; $lmargin set ylabel 'Cwnd [segment]'; plot $range '$bbr' using 1:28 with lines lc 3 title 'TCP BBR'; $fonts set terminal $extension1; set out '$deta/cwnd.$dot_extension1'; replot"

cwnd2="set grid; set xlabel 'Time [s]'; $lmargin set ylabel 'Congestion window size [segment]'; plot $range '$cubicdir/time_kernel.txt' using 1:10 with lines lc 4 title 'CUBIC TCP'; $fonts set terminal $extension1; set out '$deta/cwnd.$dot_extension1'; replot"

#btl_rtprop="set grid; set key below left ; set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$bbrdir/time_btl.txt' using 1:2 with lines lc 1 title 'Btlbw'; set y2tics; set format y2 '10^{%L}' ; set y2label 'RTprop [us]'; replot '$bbr' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; $fonts set terminal $extension1; set out '$deta/btl_rtprop.$dot_extension1'; replot"
#btl_rtprop="set grid; set key below left ; set lmargin 18  ; set rmargin 19  ; set ylabel offset -7,0  ; set y2label offset 7,0  ;set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$bbrdir/time_btl.txt' using 1:2 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'RTprop [ms]'; replot '$bbr' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; $fonts set terminal $extension1; set out '$deta/btl_rtprop.$dot_extension1'; replot"
#btl_rtprop="set grid; set key below left ; $lmargin $rmargin set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$bbr' using 1:12 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'RTprop [ms]'; replot '$bbr' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; $fonts set terminal $extension1; set out '$deta/btl_rtprop.$dot_extension1'; replot"
#btl_rtprop="set grid; $lmargin $rmargin set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$bbr' using 1:12 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'RTprop [ms]'; replot '$bbr' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; $fonts set terminal $extension1; set out '$deta/btl_rtprop.$dot_extension1'; replot"
btl_rtprop="set grid; $lmargin set xlabel 'Time [s]'; set ylabel 'Btlbw [Mbit/s]'; plot $range '$bbr' using 1:12 with lines lc 1 title 'Btlbw'; set y2tics; set y2label 'mode'; set y2range [0:3]; replot '$bbr' using 1:16  axis x1y2 with linespoints title 'mode'; $fonts set terminal $extension1; set out '$deta/btl_mode.$dot_extension1'; replot"

queue="set grid; set xlabel 'Time [s]'; $lmargin set ylabel 'Queuelength [packets]'; plot $range '$queuedir/time_kernel.txt' using 1:42 with lines lc 6 title 'queue'; $fonts set terminal $extension1; set out '$deta/queue.$dot_extension1'; replot"

#srtt="set grid; set xlabel 'Time [s]'; $lmargin set ylabel 'RTT [us]'; plot $range '$bbr' using 1:38 with lines lc 7 title 'sRTT'; $fonts set terminal $extension1; set out '$deta/srtt.$dot_extension1'; replot"
#srtt="set grid; set xlabel 'Time [s]'; $lmargin $rmargin set ylabel 'RTT [us]'; plot $range '$bbr' using 1:38 with lines lc 7 title 'sRTT';set y2tics; set y2label 'RTprop [ms]'; replot '$bbr' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; $fonts set terminal $extension1; set out '$deta/btl_rtprop.$dot_extension1'; replot"
#srtt="set grid; $lmargin set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot $range '$bbr' using 1:(\$38/1000.0) with lines lc 7 title 'sRTT';replot '$bbr' using 1:14  axis x1y2 with lines lc 2 title 'RTprop'; $fonts set terminal $extension1; set out '$deta/srtt.$dot_extension1'; replot"
#srtt="set grid; $lmargin set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot $rttrange $range '$bbr' using 1:(\$26/1000.0) with lines lc 7 title 'sRTT';replot '$bbr' using 1:(\$14/1000.0)  with lines lc 2 title 'RTprop'; $fonts set terminal $extension1; set out '$deta/srtt.$dot_extension1'; replot"
srtt="set grid; $lmargin set xlabel 'Time [s]'; set ylabel 'RTT [ms]'; plot $rttrange $range '$bbr' using 1:(\$26/1000.0) with lines lc 7 title 'sRTT';replot '$bbr' using 1:14 with lines lc 2 title 'RTprop'; $fonts set terminal $extension1; set out '$deta/srtt.$dot_extension1'; replot"

delirate="set grid; set xlabel 'Time [s]'; $lmargin $rmargin ;set ylabel 'deliverd [packets]'; plot $range '$bbr' using 1:30 with lines lc 3 title 'deliverd'; set y2tics; set y2label 'interval [us]'; replot '$bbr' using 1:36 axis x1y2 with lines lc 4 title 'interval'; $fonts set terminal $extension1; set out '$deta/delirate.$dot_extension1'; replot"
#delirate="set grid; set xlabel 'Time [s]'; set ylabel 'deliverd [packets]'; plot $range '$bbr' using 1:30 with lines lc 3 title 'deliverd'; set y2tics; set format y2 '10^{%L}' ;set y2label 'interval [ms]'; replot '$bbr' using 1:32 axis x1y2 with lines lc 4 title 'interval'; $fonts set terminal $extension1; set out '$deta/delirate.$dot_extension1'; replot"

#qdisc="set grid; set xlabel 'Time [s]'; set ylabel 'qdisc [ms]'; plot $range '$1/timeautoqdisc.txt'  using 1:14 with lines lc 3 title 'qdisc' ; $fonts set terminal $extension1; set out '$deta/qdisc.$dot_extension1' ; replot"

case "$expmode" in
    "0" ) gnuplot -e "$throughput1" & gnuplot -e "$cwnd1" & gnuplot -e "$btl_rtprop" & gnuplot -e "$queue" & gnuplot -e "$srtt" & gnuplot -e "$delirate" & gnuplot -e "$qdisc" ;;
    "1" ) gnuplot -e "$throughput2" & gnuplot -e "$cwnd2" & gnuplot -e "$queue" & gnuplot -e "$qdisc" ;;
    "2" ) gnuplot -e "$co_throughput" & gnuplot -e "$co_cwnd" & gnuplot -e  "$btl_rtprop" & gnuplot -e "$queue" & gnuplot -e "$srtt" & gnuplot -e  "$delirate" & gnuplot -e "$qdisc";;
esac
echo $srtt > srtt.plt

extension1=$extension2
dot_extension1=$dot_extension2
#done

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


