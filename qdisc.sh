dir=$1
cd /home/kanon/workspace/

python temp/qdisccheck.py $dir/cut_autoqdisc.txt
mv ./checkresult.txt $dir
sh temp/paste.sh $dir
