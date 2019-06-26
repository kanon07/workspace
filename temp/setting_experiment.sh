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

mkdir -p /media/sf_result/$today/number${num}/
log=/media/sf_result/$today/number${num}/log.txt

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
echo "setup windowsize $window" |tee $log
ssh sender1 "sh /desk/shell/set_windowsize.sh $window"
ssh sender2 "sh /desk/shell/set_windowsize.sh $window"
ssh queue "sh /desk/shell/set_windowsize.sh $window"
ssh delay "sh /desk/shell/set_windowsize.sh $window"
ssh receiver "sh /desk/shell/set_windowsize.sh $window"

#遅延時間
echo "delay ${delay}ms" |tee -a $log
ssh delay "tc qdisc replace dev eno1 root netem delay ${delay}ms"

#帯域 バッファ
echo "rate ${rate}mbit, limit $qlen" |tee -a $log
ssh queue "tc qdisc replace dev eno1 root netem rate ${rate}mbit limit $qlen"

#echo "CoDel target ${target}ms"|tee $log
# ssh queue "tc qdisc replace dev eno1 root codel target ${target}ms"

echo "================================================="
echo "start communication"

#カーネルモニタ
ssh sender1 "echo a > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo a > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo a > /proc/sane_kernel_sch_ctrl"

#unixタイムセット
ssh sender1 "sh /desk/shell/time_reset.sh"
ssh sender2 "sh /desk/shell/time_reset.sh"
date +%s.%N--set @"$(wget -q https://ntp-a1.nict.go.jp/cgi-bin/jst -O - | sed -n 4p | cut -d. -f1)"

time=`date +'%s.%N'`
timing=`echo "$time + 2" |bc`

#iperf起動
echo "======== start iperf ======="
ssh sender1 "sh /desk/shell/outiperf3.sh $conn $today $time $num"
ssh sender2 "sh /desk/shell/outiperf3.sh $conn $today $time $num"
countDown $losstime
echo "======= end iperf ======="

#カーネル抽出
echo "======== start kernel extract ========"
ssh queue "echo a > /proc/sane_kernel_sch_ctrl && sh /desk/shell/queue_monitor.sh $today $num && echo reset > /proc/sane_kernel_sch_ctrl && sh /desk/shell/pickup.sh /desk/_result/${today}/ $num" &
ssh sender1 "echo a > /proc/sane_kernel_bbr_ctrl && sh /desk/shell/pickup.sh /desk/_result/$today $num && echo reset > /proc/sane_kernel_bbr_ctrl" &
ssh sender2 "echo a > /proc/sane_kernel_tcp_ctrl && sh /desk/shell/pickup.sh /desk/_result/$today $num && echo reset > /proc/sane_kernel_tcp_ctrl"
echo "======= end kernel extract ========="

#データ移動
sh /home/kanon/workspace/temp/deta_scp.sh $today $num


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

