session=mult
window2=multi-ssh2

#tmux new-session -d -n $window -s $session
tmux new-window

tmux send-keys "ssh $1" C-m
shift

for i in $*;do
	tmux split-window
	tmux select-layout tiled
	tmux send-keys "ssh $i" C-m
done

tmux set-window-option synchronize-pane on

tmux attach-session
