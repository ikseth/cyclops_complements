#!/bin/bash

[ "$1" == "help" ] && "HELP: Process zombi sensor" && exit 0

_sensor_name="z"
_sensor_status="CHECKING"
_time=$( date +%s )
_date=$( date +%Y-%m-%d )

_ps_zombie=$( ps -eFl | awk -v _t="$_time" '$2 ~ "^Z" && $14 ~ "^[0-9]" { _dt=systime() ; _d=strftime("%Y-%m-%d",_dt) ; split(_d,a,"-") ; split($14,b,":") ;  _ot=mktime( a[1]" "a[2]" "a[3]" "b[1]" "b[2]" 0" ) ;  _diff=_dt-_ot ; if ( _diff > 21600 ) { _z++ }} END { print _z }' )

case "$_ps_zombie" in
        [0-9]*)
                _sensor_status="FAIL $_ps_zombie"
                ps aux | awk '$8 ~ "^Z" { print $0 }' 2>/dev/null > ./zombie.report.$( date +%s ).txt 
        ;;
        "")
                _sensor_status="UP $_ps_zombie"
        ;;
        *)
                _sensor_status="UNKNOWN $_ps_zombie"
        ;;
esac

echo $_sensor_name":"$_sensor_status"@"
