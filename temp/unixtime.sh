echo "start change unixtime sender1"
rm -f time.txt
rm -f unixtime.txt

while read line
do
    #echo $line | awk '{print $1}' >> unixtime.txt
    perl -waln -e 'print $F[0]' >> unixtime.txt

done < $1

start=`head -n 1 unixtime.txt`

while read line
do
    echo `/home/kanon/workspace/temp/a.out $line $start` >> time.txt

done < unixtime.txt
rm -f unixtime.txt
