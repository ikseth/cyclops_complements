#!/bin/bash

[ "$1" == "help" ] && echo "HELP: Hostname Sensor Extractor (MAIN SENSOR)" && exit 0

_sensor_name="hostname"
_sensor_status="CHECKING"

_sensor_status=$( hostname -s )

echo $_sensor_name":"$_sensor_status"@"
