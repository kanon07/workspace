. ./temp/countdown.sh
bbrconn=$1
delay=$2
today=$3
window=$4
time=$5
losstime=`expr $time + 10`
qlen=$6
rate=$7
num=$8
target=$9
expmode=${10}
option=${11}
algosender1=${12}
algosender2=${13}
pacing=${14}
tcpdump=${15}
RATEth=${16}
canon_flag=${17}
RTTth=${18}
sender1_starttime=${19}
sender2_starttime=${20}
cubicconn=${21}
sender2_flag=${22}

rm -rf /media/sf_result/$today/number${num}
rm -rf /media/sf_graphdeta/result/$today/number${num}/
mkdir -p /media/sf_result/$today/number${num}/
mkdir -p /media/sf_graphdeta/result/$today/number${num}/
log=/media/sf_result/$today/number${num}/log.txt
gragh=/media/sf_graphdeta/result/$today/number${num}/log.txt
alllog=/media/sf_result/$today/alllog.txt
graghall=/media/sf_graphdeta/result/$today/alllog.txt

echo "==================================================="
echo "start experiment $today number$num" |tee $log |tee -a $alllog

#メトリクスフラッシュ
echo "metrics_flush"
ssh sender1 "sh /desk/shell/metrics_flush.sh"
ssh sender2 "sh /desk/shell/metrics_flush.sh"

ssh sender1 "sysctl net.ipv4.tcp_congestion_control=$algosender1" |tee -a $log |tee -a $alllog
ssh sender2 "sysctl net.ipv4.tcp_congestion_control=$algosender2" |tee -a $log |tee -a $alllog

#ウィンドウサイズ
echo "setup windowsize $window" |tee -a $log |tee -a $alllog
ssh sender1 "sh /desk/shell/set_windowsize.sh $window"
ssh sender2 "sh /desk/shell/set_windowsize.sh $window"
ssh queue "sh /desk/shell/set_windowsize.sh $window"
ssh delay "sh /desk/shell/set_windowsize.sh $window"
ssh receiver "sh /desk/shell/set_windowsize.sh $window"

#遅延時間
echo "delay ${delay}ms" |tee -a $log |tee -a $alllog
ssh delay "tc qdisc replace dev eno1 root netem delay ${delay}ms"
#ssh delay "tc qdisc replace dev eno1 root netem delay ${delay}ms reorder 25% 50%"

#帯域 バッファ
echo "pfifo_fast rate ${rate}mbit, limit $qlen" |tee -a $log |tee -a $alllog
ssh queue "tc qdisc replace dev eno1 root netem rate ${rate}mbit limit $qlen"
#echo "pfifo rate 1000mbit, limit $qlen" |tee -a $log |tee -a $alllog
#ssh queue "tc qdisc replace dev eno1 root pfifo limit $qlen"
#echo "sfq rate 1000mbit" |tee -a $log |tee -a $alllog
#ssh queue "tc qdisc replace dev eno1 root sfq"

#echo "CoDel target ${target}ms"|tee -a $log |tee -a $alllog
# ssh queue "tc qdisc replace dev eno1 root codel target ${target}ms"

#pacing_gain
echo "pacing_gain=${pacing}" |tee -a $log |tee -a $alllog
ssh sender1 "echo 'set cpgp ${pacing}' > /proc/miya_bbr_tuning"

#canon_flag
echo "canon_flag=${canon_flag}" |tee -a $log |tee -a $alllog
ssh sender1 "echo $canon_flag > /proc/sys/net/ipv4/canon_flag"
#sender2_flag
echo "sender2_flag=${sender2_flag}" |tee -a $log |tee -a $alllog
ssh sender2 "echo $sender2_flag > /proc/sys/net/ipv4/canon_flag"
#RATEth
echo "RATEth=${RATEth}" |tee -a $log |tee -a $alllog
ssh sender1 "echo $RATEth > /proc/sys/net/ipv4/RATEth"
ssh sender2 "echo $RATEth > /proc/sys/net/ipv4/RATEth"
#RTTth
echo "RTTth=${RTTth}" |tee -a $log |tee -a $alllog
ssh sender1 "echo $RTTth > /proc/sys/net/ipv4/RTTth"
ssh sender2 "echo $RTTth > /proc/sys/net/ipv4/RTTth"

echo "================================================="
echo "start communication"

#カーネルモニタ
ssh sender1 "echo a > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo a > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo a > /proc/sane_kernel_sch_ctrl"

#iperf起動
echo "=========== start iperf ============"
if [ $option = 1 ]; then
    #autoqdisc=exponent_autoqdisc.sh
    autoqdisc=liner_autoqdisc.sh
    #autoqdisc=low_liner_autoqdisc.sh
    ssh delay "sh /home/shell/$autoqdisc $delay" &
fi

if [ $tcpdump = 1 ]; then
    ssh receiver "sh /root/tcpdump_count2/dump.sh $today $num $time" &
    #ssh sender1 "sh /desk/shell/dump.sh $today $num $time" &
    #ssh sender2 "sh /desk/shell/dump.sh $today $num $time" &
fi

#ifconfig
ssh sender1 "ifconfig > /root/sender1startTX.txt" &
ssh sender2 "ifconfig > /root/sender2startTX.txt" &
ssh receiver "ifconfig > /root/startRX.txt"
case "$expmode" in
    #"0" ) ssh sender1 "sh /desk/shell/outiperf3.sh $conn $today $time $num $sender1_starttime" & ssh sender2 "sh /desk/shell/ping.sh $time $today $num" &;;
    "0" ) ssh sender1 "sh /desk/shell/outiperf3.sh $bbrconn $today $time $num $sender1_starttime" &;;
    "1" ) ssh sender2 "sh /desk/shell/outiperf3.sh $cubicconn $today $time $num $sender2_starttime" &;;
    "2" ) ssh sender1 "sh /desk/shell/outiperf3.sh $bbrconn $today $time $num $sender1_starttime" & ssh sender2 "sh /desk/shell/outiperf3.sh $cubicconn $today $time $num $sender2_starttime" &;;
esac
countDown $losstime
echo "============ end iperf =============="
#ifconfig
ssh sender1 "ifconfig > sender1endTX.txt" &
ssh sender2 "ifconfig > sender2endTX.txt" &
ssh receiver "ifconfig > /root/endRX.txt" 
ssh sender1 "mv /root/*TX.txt /home/hanato/iperf_2.0.2-4_amd64-linux/_result/${today}/number${num}_Sender1/" &
ssh sender2 "mv /root/*TX.txt /home/hanato/iperf_2.0.2-4_amd64-linux/_result/${today}/number${num}_Sender2/" &

#カーネルモニタ終了
ssh sender1 "echo a > /proc/sane_kernel_bbr_ctrl" &
ssh sender2 "echo a > /proc/sane_kernel_tcp_ctrl" &
ssh queue "echo a > /proc/sane_kernel_sch_ctrl" &

#delayリセット
ssh delay "tc qdisc del dev eno1 root" &
#pacing_gainリセット
ssh sender1 "echo 'set cpgp 0' > /proc/miya_bbr_tuning" &
#RATEth リセット
ssh sender1 "echo 10 > /proc/sys/net/ipv4/RATEth" &
ssh sender2 "echo 10 > /proc/sys/net/ipv4/RATEth" &
#RTTthリセット
ssh sender1 "echo 1000 > /proc/sys/net/ipv4/RTTth" &
ssh sender2 "echo 1000 > /proc/sys/net/ipv4/RTTth" &
#canon_flag reset
ssh sender1 "echo 0 > /proc/sys/net/ipv4/canon_flag" &
ssh sender2 "echo 0 > /proc/sys/net/ipv4/canon_flag" &
#帯域 バッファ reset
ssh queue "tc qdisc del dev eno1 root"

#カーネル抽出
echo "======== start kernel extract ========"
#if [ $option = 1 ]; then
#    ssh delay "sh /home/shell/unixtime.sh /home/shell/autoqdisc.txt" &
#fi

case "$expmode" in
    "0" ) echo "only sender1" |tee -a $log |tee -a $alllog &
    ssh queue "sh /desk/shell/queue_monitor.sh $today $num" &
    ssh sender1 "sh /desk/shell/pickup.sh /desk/_result/$today $num" ;;

    "1" ) echo "only sender2" |tee -a $log |tee -a $alllog &
    ssh queue "sh /desk/shell/queue_monitor.sh $today $num" &
    ssh sender2 "sh /desk/shell/pickup.sh /desk/_result/$today $num" ;;

    "2" ) echo "co-exsisting sender1 sender2" |tee -a $log |tee -a $alllog &
    ssh queue "sh /desk/shell/queue_monitor.sh $today $num" &
    ssh sender1 "sh /desk/shell/pickup.sh /desk/_result/$today $num" &
    ssh sender2 "sh /desk/shell/pickup.sh /desk/_result/$today $num" ;;
esac
wait #バックグラウンド実行終了待ち
echo "======= end kernel extract ========="

ssh sender1 "echo reset > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo reset > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo reset > /proc/sane_kernel_sch_ctrl"


#データ移動
if [ $option = 1 ]; then
    scp delay:/home/shell/autoqdisc.txt /media/sf_result/$today/number${num}/ &
    scp delay:/home/shell/timeautoqdisc.txt /media/sf_result/$today/number${num}/ &
    scp delay:/home/shell/cut_autoqdisc.txt /media/sf_result/$today/number${num}/ &
    scp delay:/home/shell/$autoqdisc /media/sf_result/$today/number${num}/ &
    scp delay:/home/shell/autoqdisc_run_time.txt /media/sf_result/$today/number${num}/ &
fi

if [ $tcpdump = 1 ]; then
    scp receiver:/root/tcpdump_count2/data/${today}_number${num}_tcpdump_throughput.txt /media/sf_result/$today/number${num}/ &
fi

if [ $expmode = 0 ]; then
    scp sender2:/desk/shell/ping/time_${today}_number${num}_ping.txt /media/sf_result/$today/number${num}/ &
fi

scp receiver:/root/startRX.txt /media/sf_result/$today/number${num}/ &
scp receiver:/root/endRX.txt /media/sf_result/$today/number${num}/ &

sh /home/kanon/workspace/temp/deta_scp.sh $today $num $expmode
wait
#データ出力
#sh /home/kanon/workspace/gnuplot_out.sh result/$today/number${num}/ &




echo "===================" >> $alllog
echo " " >> $alllog

cp $log $gragh
cp $alllog $graghall


<< COMMENTOUT
.ssh/config


Host sender1
    HostName 192.168.1.6
    Port 22
    IdentityFile ~/.ssh/id_kanon_rsa

Host sender2
    HostName 192.168.1.4
    Port 22
    IdentityFile ~/.ssh/id_kanon_rsa

Host queue
    HostName 10.1.1.10
    Port 22
    ProxyCommand ssh -W %h:%p sender1
    IdentityFile ~/.ssh/id_kanon_rsa

Host delay
    HostName 10.1.1.11
    Port 22
    ProxyCommand ssh -W %h:%p queue
    IdentityFile ~/.ssh/id_kanon_rsa

Host receiver
    HostName 10.1.1.3
    Port 22
    ProxyCommand ssh -W %h:%p queue
    IdentityFile ~/.ssh/id_kanon_rsa
COMMENTOUT

