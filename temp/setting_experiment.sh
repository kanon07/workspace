. ./temp/countdown.sh
conn=$1
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

rm -rf /media/sf_result/$today/number${num}
mkdir -p /media/sf_result/$today/number${num}/
log=/media/sf_result/$today/number${num}/log.txt
alllog=/media/sf_result/$today/alllog.txt

echo "==================================================="
echo "start experiment"


#モニターリセット
echo "monitor reset"
ssh sender1 "echo reset > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo reset > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo reset > /proc/sane_kernel_sch_ctrl"

#メトリクスフラッシュ
echo "metrics_flush"
ssh sender1 "sh /desk/shell/metrics_flush.sh"
ssh sender2 "sh /desk/shell/metrics_flush.sh"

#ウィンドウサイズ
echo "setup windowsize $window" |tee $log |tee -a $alllog
ssh sender1 "sh /desk/shell/set_windowsize.sh $window"
ssh sender2 "sh /desk/shell/set_windowsize.sh $window"
ssh queue "sh /desk/shell/set_windowsize.sh $window"
ssh delay "sh /desk/shell/set_windowsize.sh $window"
ssh receiver "sh /desk/shell/set_windowsize.sh $window"

#遅延時間
echo "delay ${delay}ms" |tee -a $log |tee -a $alllog
ssh delay "tc qdisc replace dev eno1 root netem delay ${delay}ms"

#帯域 バッファ
echo "rate ${rate}mbit, limit $qlen" |tee -a $log |tee -a $alllog
ssh queue "tc qdisc replace dev eno1 root netem rate ${rate}mbit limit $qlen"

#echo "CoDel target ${target}ms"|tee -a $log |tee -a $alllog
# ssh queue "tc qdisc replace dev eno1 root codel target ${target}ms"

echo "================================================="
echo "start communication"

#カーネルモニタ
ssh sender1 "echo a > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo a > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo a > /proc/sane_kernel_sch_ctrl"

#iperf起動
echo "======== start iperf ======="
if [ $option = 1 ]; then
    ssh delay "sh /home/shell/qdisc_deta.sh" >> $log &
fi
case "$expmode" in
    "0" ) ssh sender1 "sh /desk/shell/outiperf3.sh $conn $today $time $num" ;;
    "1" ) ssh sender2 "sh /desk/shell/outiperf3.sh $conn $today $time $num" ;;
    "2" ) ssh sender1 "sh /desk/shell/outiperf3.sh $conn $today $time $num" & ssh sender2 "sh /desk/shell/outiperf3.sh $conn $today $time $num" ;;
esac
countDown $losstime
echo "======== end iperf ======"

#カーネルモニタ終了
ssh sender1 "echo a > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo a > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo a > /proc/sane_kernel_sch_ctrl"

#カーネル抽出
echo "======== start kernel extract ========"
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
echo "======= end kernel extract ========="

ssh sender1 "echo reset > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo reset > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo reset > /proc/sane_kernel_sch_ctrl"


#データ移動
sh /home/kanon/workspace/temp/deta_scp.sh $today $num $expmode

echo "===================" >> $alllog
echo " " >> $alllog



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

