#!/bin/bash
startnum=$1
endnum=$2
today=$3
rm -f ${today}_th_ave.txt
for i in `seq $startnum $endnum`
do

    #echo num=$i `cat result/$today/number${i}/number${i}_Sender1/sender1_iperf_30.txt |grep sender` >> ${today}_th_ave.txt
    echo num=$i `cat result/$today/number${i}/number${i}_Sender2/sender2_iperf_30.txt |grep sender` >> ${today}_th_ave.txt

done

