#!/bin/bash

[ $1 == "help" ] && echo "HELP: Linux Raid Control Sensor, options: [SENSOR NAME] [MD DEV]" >&2 && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

_sensor_md_cmd=$( which mdadm 2>/dev/null )
_sensor_md_dev="/dev/$2"

if [ -z "$_sensor_md_cmd" ]
then
        _sensor_status="DISABLE no cmd"
else
        _sensor_status=$( $_sensor_md_cmd --detail $_sensor_md_dev | sed 's/^ *//' | awk -F":" '
                $1 ~ "^State" { 
                        if ( $2 ~ "clean" ) { 
                                _s="OK" 
                        } else { 
                                if ( $2 ~ "active" ) {
                                        _s="OK"
                                } else {
                                        _s="FAIL "$2 
                                }
                        }
                } $1 ~ "Active Devices" { 
                        _ad=$2 
                } $1 ~ "Failed Devices" { 
                        _fd=$2 ;
                        if ( _fd != 0 ) { _s="FAIL" } 
                } $1 ~ "Total Devices" { 
                        _td=$2 
                } END { 
                        print _s" "int(_td)"/"int(_ad)"/"int(_fd) 
                }' )
fi

echo $_sensor_name":"$_sensor_status"@"
