#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

_sensor_name="uptime"
_sensor_status="CHECKING"

[ "$1" == "help" ] && echo "HELP: base uptime sensor" && exit

_sensor_status=`cat /proc/uptime | awk '{ sum = $1/86400; print sum}' | sed 's/\..*/d/'` 

[[ $_sensor_status == [0-3]d ]] && _sensor_status="CHECKING "$_sensor_status || _sensor_status="UP "$_sensor_status

echo $_sensor_name":"$_sensor_status"@"
