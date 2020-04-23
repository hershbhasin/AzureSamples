
#!/bin/bash
export asg_name=hb_win_asg
export size=1

aws autoscaling update-auto-scaling-group \
--auto-scaling-group-name $asg_name \
--min-size $size \
--max-size $size \
--desired-capacity $size
