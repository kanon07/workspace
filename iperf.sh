#!/bin/bash
startnum=$1
endnum=$2
today=$3
file1=${today}_startnum${startnum}_endnum${endnum}_1.txt
file2=${today}_startnum${startnum}_endnum${endnum}_2.txt
rm -f $file1
rm -f $file2

for i in `seq $startnum $endnum`
do
    data1=result/$today/number${i}/number${i}_Sender1/sender1_iperf_30.txt
    data2=result/$today/number${i}/number${i}_Sender2/sender2_iperf_30.txt

    #echo num=$i `cat result/$today/number${i}/number${i}_Sender1/sender1_iperf_30.txt |grep sender` >> ${today}_th_ave.txt
    #echo num=$i `cat result/$today/number${i}/number${i}_Sender2/sender2_iperf_30.txt |grep sender` >> $file
    sum1=`echo $sum1 $data1`
    sum2=`echo $sum2 $data2`

    #paste $file $data1 > $file

done
cat $sum1 > $file1
cat $sum2 > $file2

