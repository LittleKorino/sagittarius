#!/system/bin/sh
#tasker.sh

source /data/adb/modules/sagittarius/utils.sh

LOG=/data/adb/modules/sagittarius/logs/taskerTaskRun.log
TASK_NAME=$1

log "Broadcasting Tasker Task: $TASK_NAME" 
am broadcast -a net.dinglisch.android.tasker.ACTION_TASK --es task_name $TASK_NAME 2>&1 | tee -a "$LOG"
