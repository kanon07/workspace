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

mkdir -p /media/sf_graphdeta/$1/number${2}
deta=/media/sf_graphdeta/$1/number${2}

#gnuplot -e "set xlabel 'time [s/10]'; set ylabel 'Throughput [Mbps]'; set xrange [0:300]; set yrange [0:2000]; plot '$bbr' using 0:7 with lines title 'TCP BBR'; replot '$cubic' using 0:7 with lines title 'CUBIC TCP'; pause -1"
gnuplot -e "set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:2000]; plot '$bbr' using 0:7 with lines title 'TCP BBR'; replot '$cubic' using 0:7 with lines title 'CUBIC TCP'; set terminal png; set out '$deta/throughput.png'; replot"

gnuplot -e "set terminal x11 3; set grid; set xlabel 'Time [s]'; set ylabel 'Throughput [Mbps]'; set yrange [0:2000]; plot '$bbr' using 0:7 with lines title 'TCP BBR'; replot '$cubic' using 0:7 with lines title 'CUBIC TCP'; pause -1"

#display $1/number$2.png
