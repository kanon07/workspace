dir=$1
number=$2

sh gnuplot_throughput.sh $dir $number
sh gnuplot_kernel.sh $dir $number
