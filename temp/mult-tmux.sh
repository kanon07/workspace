if [-n "$SESSION_NAME" ];then
	session=$SESSION_NAME
else
	session=multi-ssh-`date +%s`
fi
window=multi-ssh

tmux new-session -d -n $window -s $session

tmux send-keys "ssh $1" C-m
shift

for i in $*;do
	tmux split-window
	tmux select-layout tiled
	tmux send-keys "ssh $i" C-m
done

tmux select-pane -t 0
tmux set-window-option synchronize-pane on

tmux attach-session -t $session
