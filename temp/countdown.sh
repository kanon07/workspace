countDown()
{
    start=1
    end=$1
    while [ $start -le $end ]
    do
        printf "The left time is $(($end-$start)) seconds\r"
        sleep 1
        start=$(($start+1))
    done
}

