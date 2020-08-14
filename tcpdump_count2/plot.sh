dir=$1
#../result/0515/number1/0515_number1_tcpdump_throughput.txt
gnuplot -e "set ylabel 'throughput [B/s]'; plot '$dir' using 0:3 with lines; pause -1;"
