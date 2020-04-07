#!/bin/bash

_sensor_name=$1
_sensor_status="CHECKING"

[ "$1" == "help" ] && echo "HELP: service monitor sensor: [SERVICE NAME]" && exit 

_daemon_value=$( /etc/init.d/$_sensor_name status 2>/dev/null >/dev/null; echo $?)
case $_daemon_value in
0)
	_sensor_status="UP"
;;
1)
	_sensor_status="DOWN stop"
;;
"")
	_sensor_status="UNKNOWN no data"
;;
*)
	_sensor_status="DOWN err.($_daemon_value)"
;;
esac

echo $_sensor_name":"$_sensor_status"@"
