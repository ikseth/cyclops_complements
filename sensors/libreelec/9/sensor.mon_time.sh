#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

_sensor_name="mon_time"
_sensor_status="CHECKING"

[ "$1" == "help" ] && echo "HELP: base monitor time sensor" && exit

_sensor_status=`date +%H.%M.%S` 

echo $_sensor_name":"$_sensor_status"@"
