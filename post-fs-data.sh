#!/system/bin/sh
# post-fs-data.sh

## Enable ADBD on tcp 5555
resetprop service.adb.tcp.port 5555
resetprop ro.debuggable 1
stop adbd
start adbd

