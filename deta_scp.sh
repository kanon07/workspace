date=$1
scp -r -i ~/.ssh/id_rsa 192.168.1.6:/desk/_result/$1 /home/kanon/deta/_result
scp -r -i ~/.ssh/id_rsa 192.168.1.4:/desk/_result/$1 /home/kanon/deta/_result/
