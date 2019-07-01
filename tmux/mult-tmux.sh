session=mult

window=multi-ssh
window2=multi-ssh2

tmux new-session -d -n $window -s $session
#tmux new-session -d -n $window2 -s $session

tmux send-keys "ssh $1" C-m
shift

for i in $*;do
	tmux split-window
	tmux select-layout tiled
	tmux send-keys "ssh $i" C-m
done

tmux select-pane -t 0
tmux set-window-option synchronize-pane on

