today=$1
num=$2
resultdir=/media/sf_result/$today/number${num}/
mkdir -p $resultdir

echo "========= start deta move =========="
scp -r sender1:/desk/_result/$today/number${num}_Sender1/ $resultdir
scp -r sender2:/desk/_result/$today/number${num}_Sender2/ $resultdir
scp -r queue:/desk/_result/$today/number${num}_queue/ $resultdir
echo "========= end deta move =========="
