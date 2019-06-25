ssh sender1 "echo a > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo a > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo a > /proc/sane_kernel_sch_ctrl"

ssh sender1 "echo reset > /proc/sane_kernel_bbr_ctrl"
ssh sender2 "echo reset > /proc/sane_kernel_tcp_ctrl"
ssh queue "echo reset > /proc/sane_kernel_sch_ctrl"

ssh sender1 "cat /proc/sane_kernel_bbr_ctrl"
ssh sender2 "cat /proc/sane_kernel_tcp_ctrl"
ssh queue "cat /proc/sane_kernel_sch_ctrl"
