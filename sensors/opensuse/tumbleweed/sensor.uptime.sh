#!/bin/bash

[ "$1" == "help" ] && "HELP: node uptime sensor" && exit 0

_sensor_name="uptime"
_sensor_status="CHECKING"

_sensor_status=$( awk '{ sum = $1/86400; print sum}' /proc/uptime | sed 's/\..*/d/' )

[[ $_sensor_status == [0-3]d ]] && _sensor_status="CHECKING "$_sensor_status || _sensor_status="UP "$_sensor_status

echo $_sensor_name":"$_sensor_status"@"
