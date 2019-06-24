#conn=$1
#delay=$2
#today=$3
#window=$4
#time=$5
#losstime=$5+10
#qlen=$6
#rate=$7
#num=$8
#target=$9

#ssh -i /home/kanon/.ssh/id_rsa 192.168.1.6 "echo a > /proc/sane_kernel_bbr_ctrl"
#ssh -i /home/kanon/.ssh/id_rsa 192.168.1.4 "echo a > /proc/sane_kernel_tcp_ctrl"
scp -r -o "ProxyCommand ssh -i /root/.ssh/id_rsa 192.168.1.6 -W %h:%p" 10.1.1.10:echo a > /proc/sane_kernel_sch_ctrl



#ssh -i /home/kanon/.ssh/id_rsa 192.168.1.6 "echo a > /proc/sane_kernel_bbr_ctrl"
#ssh -i /home/kanon/.ssh/id_rsa 192.168.1.6 "echo a > /proc/sane_kernel_bbr_ctrl"
#ssh -i /home/kanon/.ssh/id_rsa 192.168.1.6 "echo a > /proc/sane_kernel_bbr_ctrl"
#ssh -i /home/kanon/.ssh/id_rsa 192.168.1.6 "echo a > /proc/sane_kernel_bbr_ctrl"

