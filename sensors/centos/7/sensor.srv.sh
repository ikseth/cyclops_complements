#!/bin/bash
#@HELP@ This Sensor needs daemon name, is important the daemon behavior was an standard (status output)
#@HELP@ This Sensor need to control the OS to execute the right command

[ "$1" == "help" ] && echo "HELP: service/daemon status sensor, options: [SENSOR NAME] [COMMAND]" && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

_sensor_cmd=$( which service 2>/dev/null )

[ -z "$_sensor_cmd" ] && [ ! -z "$2" ] && [ -f "$2" ] && _sensor_cmd=$2

if [ -z "$_sensor_cmd" ]
then
        _sensor_status="DISABLE no cmd"
else
        _daemon_value=$( $_sensor_cmd $_sensor_name status 2>/dev/null >/dev/null; echo $?)
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
fi

echo $_sensor_name":"$_sensor_status"@"
