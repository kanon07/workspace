#today=`date +"%Y%m%d"`
today=`date +"%m%d"`

startnum=$1
endnum=$2
expmode=0

conn=1
delay=0
window=209715200
time=120
rate=500
target=5

#通信量確認
tcpdump=0

pacing=0
RATEth=30
RTTth=5000
canon_flag=0
sender1_starttime=0
sender2_starttime=0
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
    num=$i
    #qlen=`echo "1024 * (4 ^ ($cnt -1 ))"|bc`
    #qlen=`echo "16384 * (4 ^ ($cnt -1 ))"|bc`
    qlen=1000

    #option 1=on 0=off
    option=1

    #0=sender1
    #1=sender2
    #2=multi
    expmode=0
    algosender1=bbr
    algosender2=cubic

    #if [ $(($cnt % 10)) = 0 ] && [ $cnt != 0 ]; then
    #    RATEth=10
    #    RTTth=$((RTTth + 1000))
    #fi

    sh ./temp/setting_experiment.sh $conn $delay $today $window $time $qlen $rate $num $target $expmode $option $algosender1 $algosender2 $pacing $tcpdump $RATEth $canon_flag $RTTth $sender1_starttime $sender2_starttime

    #expmode=$(( expmode + 1))
    #pacing=$((pacing + 1))
    #delay=$((delay + 10))
    #window=$((window - 41943040))
    #RATEth=$((RATEth + 10))
    #RTTth=$((RTTth + 1))
    canon_flag=$((canon_flag + 1))
    #cnt=$((cnt + 1))
    #sender2_starttime=$((sender2_starttime + 15))
done

