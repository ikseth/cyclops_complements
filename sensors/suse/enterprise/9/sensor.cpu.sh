#!/bin/bash

[ "$1" == "help" ] && echo "HELP: cpu monitor sensor, sysstat package dependency" && exit 0

_sensor_name="cpu"
_sensor_status="CHECKING"

_sensor_cmd=$( which mpstat 2>/dev/null )
if [ -z "$_sensor_cmd" ] 
then
	_sensor_name="DISABLE no cmd"
else
	_cpu=$( $_sensor_cmd 1 1 | awk '$1 == "Average:" { print int($(NF-1)) }' )

	let _cpu=100-$_cpu

	if [ -z "$_cpu" ]
	then
		_sensor_status="MARK sensor err"
	else
		case "$_cpu" in
			[0-9]|[1-4][0-9])
				_sensor_status="UP $_cpu%"
			;;
			[5-6][0-9])
				_sensor_status="OK $_cpu%"
			;;
			100|[7-9][0-9])
				_sensor_status="MARK $_cpu%"
			;;
			*)
				_sensor_status="UNKN $_cpu"
			;;
			esac
	fi
fi

echo $_sensor_name":"$_sensor_status"@"
