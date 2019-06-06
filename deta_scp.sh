date=$1
scp -r -i ~/.ssh/id_rsa 192.168.1.6:/desk/_result/$1 /home/kanon/workspace/_result
scp -r -i ~/.ssh/id_rsa 192.168.1.5:/desk/_result/$1 /home/kanon/workspace/_result
