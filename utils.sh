#!/system/bin/sh
#utils.sh

apply_priority() {

    pattern="$1"
    # Find PIDs matching the pattern (using -f for full command line match)
    pids=$(pgrep -f "$pattern")

    for pid in $pids; do
        
	    renice -n -20 -p "$pid"

	    if [ -f "/proc/$pid/oom_score_adj" ]; then

		    echo "-1000" > "/proc/$pid/oom_score_adj"
	    fi
    done

}

launchTasker() {
    am start -n net.dinglisch.android.taskerm/.Tasker
    sleep 2
    input keyevent KEYCODE_BACK
    sleep 2
    input keyevent KEYCODE_HOME
    sleep 2
}

log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$msg"          # print to terminal
    echo "$msg" >> "$LOG"  # append to log file
}


wait_and_prioritize() {
    local target="$1"
    local retries="${2:-40}" # Default to 40 retries if not specified
    
    for i in $(seq 1 "$retries"); do
        # -f matches full command line (good for java/package names)
        if pgrep -f "$target" > /dev/null; then
            apply_priority "$target"
            log "Priority applied to: $target"
            return 0
        fi
        sleep 0.5
    done
    log "WARNING: Timed out waiting for $target"
    return 1
}

hotspotstate() {
    state=$(ip link show ap0 | awk '/state/ {printf $9}')
    echo $state
}
