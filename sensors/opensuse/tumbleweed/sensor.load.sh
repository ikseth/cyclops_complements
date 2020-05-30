#!/bin/bash

[ "$1" == "help" ] && echo "HELP: server load average sensor: [name] [ip interval (1|5|15)] [WARN|ALERT]" && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

[ -z "$2" ] && _interval=5 || _interval=$2
[ "$3" == "ALERT" ] && _status="FAIL" || _status="MARK" ## ALLOW TO CHANGE IF SENSOR TRIGGER AN ALERT OR NOT

_sensor_cmd=$( which uptime 2>/dev/null )

### SCRIPT [ CONTROL OUTPUT TO NULL OR TO FILE ONLY LAST COMMAND SEND OUTPUT TO >1 ]

# available sensor status [DISABLE|OK|UP|DOWN|ALERT|WARN] after that you can print value, if don't use status cyclops ignore it but you add value to have sensor statistics data
if [ -z "$_sensor_cmd" ]
then
        _sensor_status="DISABLE no cmd"
else
        _cores=$( grep processor /proc/cpuinfo | wc -l )
        _sensor_status=$( $_sensor_cmd | awk -v _i="$_interval" -v _c="$_cores" -v _s="$_status" '
                BEGIN {
                        f=0 ; _c=int(_c)
                        if ( _i == 1 ) {  f=1 }
                        if ( _i == 5 ) {  f=2 }
                        if ( _i == 15 ) { f=3 }
                } {
                        for (m=1;m<=NF;m++) { if ( $m ~ "average" ) { _field=m ; break } }
                        _load=$(_field+f)
                } END {
                        if ( f == 0 ) {
                                print "DISABLE snr stng"
                        } else {
                                _load=int((_load*100)/_c)
                                if ( _load > 100 ) { _status=_s } else { _status="UP" }
                                print _status" "_load"%"
                        }
                }' )
fi

echo $_sensor_name":"$_sensor_status"@"
