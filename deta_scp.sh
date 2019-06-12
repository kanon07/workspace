date=$1
resultdir=/media/sf_result/

scp -r -i ~/.ssh/id_rsa 192.168.1.6:/desk/_result/$1 $resultdir
scp -r -i ~/.ssh/id_rsa 192.168.1.4:/desk/_result/$1 $resultdir
scp -r -o "ProxyCommand ssh -i /root/.ssh/id_rsa 192.168.1.6 -W %h:%p" 10.1.1.10:/desk/_result/$1 $resultdir
