today=`date +"%Y%m%d"`

startnum=$1
endnum=$2

for i in `seq ${startnum} ${endnum}`
do
num=$i
delay=0
conn=1
window=33554432
time=300
qlen=`echo "1024 * (4 ^ ($i -1 ))"|bc`
rate=1000
target=5

echo "start number${num}"
sh ./temp/setting_experiment.sh $conn $delay $today $window $time $qlen $rate $num $target

done

#10485760
#20971520
#33554432
#104857600
#419430400
