#!/system/bin/sh
# service.sh

MODDIR="/data/adb/modules/sagittarius"
LOG="$MODDIR/logs/Main.log"

## Utils.sh
source "$MODDIR/utils.sh"

## Set hostname as sagittarius
"$MODDIR/set-hostname.sh"

## Wait for Android boot
while [ "$(resetprop sys.boot_completed)" != "1" ]; do sleep 5; done

## Enable data and wifi
svc data enable
svc wifi enable

## Wait for network
MAX_RETRIES=60
COUNT=0
while ! ping -c1 8.8.8.8 >/dev/null 2>&1; do
    sleep 5
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $MAX_RETRIES ]; then
        log "Network failure, booting offline"
        break
    fi
done

## Run tailscale daemon
LOG="$MODDIR/logs/tailscaled.log"
TS_DIR="/data/local/korino"
export HOME="$TS_DIR"
export TMPDIR="/data/local/tmp"
( "$MODDIR/runTailscaled.sh" 2>&1 | tee "$LOG" )&
wait_and_prioritize "tailscaled"

## Enable Termux
LOG="$MODDIR/logs/termux-start.log"
( "$MODDIR/runTermuxCommandIntent.sh" '/data/data/com.termux/files/usr/sbin/start-sshd.sh' 2>&1 | tee "$LOG" )&
wait_and_prioritize "com.termux"
wait_and_prioritize "sshd"

## Wait for Tasker
TARGET_PROC="net.dinglisch.android.taskerm"
wait_and_prioritize "$TARGET_PROC" 200

## Enable WIFI Hotspot
"$MODDIR/tasker.sh" HotspotUhh

## Enable Bridge
LOG="$MODDIR/logs/networkbridge.log"
/data/local/korino/netbridge/bridge.sh
apply_priority "bridge_watchdog.sh"

## Disable Quic
"$MODDIR/disableQUIC.sh"
if [ $? -eq 0 ]; then
    log "QUIC protocol has been disabled"
else
    log "QUIC NOT DISABLED"
fi

## Finish
"$MODDIR/say.sh" "Device Booted successfully!"
