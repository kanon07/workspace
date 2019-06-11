#$1=directory 0606, 0705
#$2=number

bbrtemp=${1}/
cubictemp=${1}/
bbrdir=${bbrtemp}number${2}_Sender1
cubicdir=${cubictemp}number${2}_Sender2

bbr=`find ${bbrdir} -name *bbr*limit*.txt`
cubic=`find ${cubicdir} -name *cubic*limit*.txt`
echo $bbr
echo $cubic

#gnuplot -e "set xlabel 'time [s/10]'; set ylabel 'Throughput [Mbps]'; set xrange [0:300]; set yrange [0:2000]; plot '$bbr' using 0:7 with lines title 'TCP BBR'; replot '$cubic' using 0:7 with lines title 'CUBIC TCP'; pause -1"
gnuplot -e "set grid; set xlabel 'time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:2000]; plot '$bbr' using 0:7 with lines title 'TCP BBR'; replot '$cubic' using 0:7 with lines title 'CUBIC TCP'; set terminal png; set out '$1/number$2.png'; replot"

gnuplot -e "set terminal x11 3; set grid; set xlabel 'time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:2000]; plot '$bbr' using 0:7 with lines title 'TCP BBR'; replot '$cubic' using 0:7 with lines title 'CUBIC TCP'; pause -1"

#display $1/number$2.png
