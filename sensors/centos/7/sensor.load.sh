#!/bin/bash

[ "$1" == "help" ] && echo "HELP: server load average sensor: [name] [ip interval (1|5|15)] [WARN|ALERT]" && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

[ -z "$2" ] && _interval=5 || _interval=$2
[ "$3" == "ALERT" ] && _status="FAIL" || _status="MARK" ## ALLOW CHANGE IF SENSOR TRIGGER AN ALERT OR NOT

_sensor_cmd=$( which uptime 2>/dev/null )

if [ -z "$_sensor_cmd" ]
then
        _sensor_status="DISABLE no cmd"
else
        _cores=$( grep processor /proc/cpuinfo | tail -n 1 | cut -d':' -f2 )
        _sensor_status=$( $_sensor_cmd | cut -d':' -f5- | awk -F\, -v _i="$_interval" -v _c="$_cores" -v _s="$_status" '
                BEGIN {
                        f=0 ; _c=int(_c)
                        if ( _i == 1 ) {  f=1 }
                        if ( _i == 5 ) {  f=2 }
                        if ( _i == 15 ) { f=3 }
                } {
                        _load=$f
                } END {
                        if ( f == 0 ) {
                                print "DISABLE no data"
                        } else {
                                _load=int((_load*100)/_c)
                                if ( _load > 100 ) { _status=_s } else { _status="UP" }
                                print _status" "_load"%"
                        }
                }' )
fi

echo $_sensor_name":"$_sensor_status"@"
