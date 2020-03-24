#!/bin/bash

[ [ "$1" == "help" ] && echo "HELP: mon time main sensor" && exit 0

_sensor_name="mon_time"
_sensor_status="CHECKING"

source /etc/cyclops/global.cfg ## OWN EXEC ##

_sensor_status=`date +%H.%M.%S` 

echo $_sensor_name":"$_sensor_status"@"
