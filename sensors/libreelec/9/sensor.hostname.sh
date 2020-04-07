#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

_sensor_name="hostname"
_sensor_status="CHECKING"

[ "$1" == "help" ] && echo "HELP: hostname base sensor" && exit

_sensor_status=$( hostname -s ) 

echo $_sensor_name":"$_sensor_status"@"
