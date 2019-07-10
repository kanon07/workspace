scp delay:/home/shell/autoqdisc.txt ./
sh cut.sh autoqdisc.txt
sh unixtime.sh cut_autoqdisc.txt 
paste time.txt cut_autoqdisc.txt > time_autoqdisc.txt
rm -f autoqdisc.txt cut_autoqdisc.txt time.txt 
gnuplot -e "set xrange [0:300];plot 'time_autoqdisc.txt' using 1:14; pause -1"
gnuplot -e "set xrange [0:300];plot 'time_autoqdisc.txt' using 1:14; set terminal png; set out 'ping.png'; replot"
