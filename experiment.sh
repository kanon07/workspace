today=`date +"%Y%m%d"`

startnum=$1
endnum=$2
expmode=0

conn=1
delay=5
window=104857600
#window=$3
time=300
rate=1000
target=5

#qlen=16384

cnt=0
for i in `seq ${startnum} ${endnum}`
do
    cnt=$((cnt + 1))
    num=$i
    #qlen=`echo "1024 * (4 ^ ($cnt -1 ))"|bc`
    qlen=`echo "16384 * (4 ^ ($cnt -1 ))"|bc`


    #option 1=on 0=off
    option=0

    #0=sender1
    #1=sender2
    #2=multi
    expmode=2

    echo "start number${num}"
    sh ./temp/setting_experiment.sh $conn $delay $today $window $time $qlen $rate $num $target $expmode $option
    echo $qlen

    #expmode=$(( expmode + 1))
done

#10485760
#20971520
#33554432
#104857600
#419430400
