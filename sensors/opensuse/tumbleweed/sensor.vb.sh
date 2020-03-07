#!/bin/bash

[ $1 == "help" ] && echo "HELP: Virtualbox guest status sensor, options: [SENSOR NAME] [VBOX GUEST NAME] [VBOX USER]" >&2 && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

_sensor_vboxguest=$2
_sensor_vboxusr=$3
_sensor_vboxcmd=$( which VBoxManage 2>/dev/null)

if [ -z "$_sensor_vboxcmd" ]
then
        _sensor_status="DISABLE no cmd"
else
        _sensor_status=$( su - $_sensor_vboxusr -c "$_sensor_vboxcmd showvminfo $_sensor_vboxguest" | awk '
                BEGIN { 
                        _s=0
                } $1 == "State:" { 
                        if ( $2 == "running" ) { 
                                _time=gensub(/([0-9]...)-([0-9].)-([0-9].)T([0-9].):([0-9].):([0-9].).*/,"\\1 \\2 \\3 \\4 \\5 \\6","g",$4) ; 
                                _ts=mktime( _time ) ; 
                                _now=systime() ; 
                                _s="UP "int(( _now - _ts )/86400)"d" 
                        } else { 
                                _s="FAIL "$2 
                        }
                } END {
                        if ( _s != 0 ) {
                                print _s 
                        } else {
                                print "DISABLE miss sensor"
                        }
                }' )
fi

echo $_sensor_name":"$_sensor_status"@"
