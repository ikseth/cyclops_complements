#!/bin/bash
#UPPER PROCESS USER EXEC

_sensor_name="psnum"
_sensor_status="CHECKING"

[ "$1" == "help" ] && echo "HELP: process sensor options: [SENSOR NAME] [USER] [PROCESS NAME] [MIN NUM] [MAX NUM] [WARN|ALERT]" && exit 0

[ ! -z "$1" ] && _sensor_name=$_sensor_name"_"$1
[ ! -z "$2" ] && _sensor_usr=$2
[ ! -z "$3" ] && _sensor_pro=$3
[ "$6" == "ALERT" ] && _sensor_sts="ALERT" || _sensor_sts="MARK"

_sensor_status=$( ps -eFl | awk -v _susr="$_sensor_usr" -v _spro="$_sensor_pro" -v _mn="$4" -v _tn="$5" -v _ss="$_sensor_sts" '
	BEGIN { 
		_status="UP"
		_pc=0 
	} $3 == _susr || $0 ~ _spro { 
		_pc++  
	} END { 
		if ( _tn != "" && _pc >= _tn ) { _status=_ss }
		if ( _tn != "" && _pc <= _tn ) { _status=_ss }
		print _status" "_pc 
	}' )

echo $_sensor_name":"$_sensor_status"@"

