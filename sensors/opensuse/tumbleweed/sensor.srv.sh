#!/bin/bash
#@HELP@ This Sensor needs daemon name, is important the daemon behavior was an standard (status output)
#@HELP@ This Sensor need to control the OS to execute the right command
#@DAEMON@_sensor_name="DAEMON"

[ "$1" == "help" ] && echo "HELP: Service sensor: [SERVICE NAME]" && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

source /etc/cyclops/global.cfg ## OWN EXEC ##

_daemon_value=$( service $_sensor_name status 2>/dev/null >/dev/null; echo $?)
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
