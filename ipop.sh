#today=`date +"%Y%m%d"`
today=`date +"%m%d"`

startnum=$1
endnum=$2
expmode=2

conn=1
delay=5
window=104857600
time=3000
rate=100
target=5

#0=normal 1=aggressive 2=more_aggressive
pacing=0
#10485760
#20971520
#33554432
#104857600
#209715200
#419430400
#window=$3

#qlen=16384

cnt=0
for i in `seq ${startnum} ${endnum}`
do
    cnt=$((cnt + 1))
    num=$i
    #qlen=`echo "1024 * (4 ^ ($cnt -1 ))"|bc`
    #qlen=`echo "16384 * (4 ^ ($cnt -1 ))"|bc`
    qlen=65536

    #option 1=on 0=off
    option=0

    #0=sender1
    #1=sender2
    #2=multi
    expmode=2
    algosender1=bbr
    algosender2=cubic

    sh ./temp/setting_experiment.sh $conn $delay $today $window $time $qlen $rate $num $target $expmode $option $algosender1 $algosender2 $pacing

done

