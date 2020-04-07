#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

_sensor_name="swap"
_sensor_status="CHECKING"

source /etc/cyclops/global.cfg ## OWN EXEC ##

_swp=`vmstat | awk '{ print $3 }' | tail -n 1`
_space=`swapon -s | tail -n 1 | awk '{ print $3}'`
let _total=($_swp*100)/$_space

case "$_total" in
	[0-5])
		_sensor_status="UP"
	;;
	[5-9])
		_sensor_status="OK $_total%"
	;;
	[1-4][0-9])
		_sensor_status="FAIL $_total%"
	;;
	[5-9][0-9]|100)
		sensor_status="DOWN $_total%"
	;;
	*)
		sensor_status="UNKNOWN"
	;;
esac

echo $_sensor_name":"$_sensor_status"@"
