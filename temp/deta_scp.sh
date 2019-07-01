today=$1
num=$2
expmode=$3
resultdir=/media/sf_result/$today/number${num}/
mkdir -p $resultdir

echo "========= start deta move =========="

case "$expmode" in
    "0" )  scp -r sender1:/desk/_result/$today/number${num}_Sender1/ $resultdir &
    scp -r queue:/desk/_result/$today/number${num}_queue/ $resultdir ;;

    "1" ) scp -r sender2:/desk/_result/$today/number${num}_Sender2/ $resultdir &
    scp -r queue:/desk/_result/$today/number${num}_queue/ $resultdir ;;

    "2" ) scp -r sender1:/desk/_result/$today/number${num}_Sender1/ $resultdir &
    scp -r sender2:/desk/_result/$today/number${num}_Sender2/ $resultdir &
    scp -r queue:/desk/_result/$today/number${num}_queue/ $resultdir ;;
esac

echo "========= end deta move =========="
