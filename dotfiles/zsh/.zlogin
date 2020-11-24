UPTIME_FLOAT=$(awk '{print $1}' /proc/uptime)
UPTIME=$(printf "%.0f" $UPTIME_FLOAT)

# Runs motd when the PC has an uptime of less than 10 seconds
if [ "$UPTIME" -lt 10 ]; then
    run-parts /etc/update-motd.d
fi
