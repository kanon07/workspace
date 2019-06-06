#$1=directory
#$2=number

bbrdir=${1}number${2}_Sender1
cubicdir=${1}number${2}_Sender2

bbr=`find ${bbrdir} -name *bbr*limit*.txt`
cubic=`find ${cubicdir} -name *cubic*limit*.txt`
echo $bbr
echo $cubic

gnuplot -e "set xlabel 'time [s/10]'; set ylabel 'Throughput [Mbps]'; set xrange [0:3000]; set yrange [0:2000]; plot '$bbr' using 0:7 with lines title 'TCP BBR'; replot '$cubic' using 0:7 with lines title 'CUBIC TCP'; pause -1"


