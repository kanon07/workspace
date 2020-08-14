grep "> 10.1.1.30.commplex-main:" tcpdump.txt | ruby tcpcount.rb

gnuplot -e "plot '../result/0515/number1/0515_number1_tcpdump_throughput.txt' using 0:3 with lines; pause -1;"

