#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

_sensor_status="CHECKING"

[ "$1" == "help" ] && echo "HELP: mem control sensor: [SENSOR NAME] [MEM PROC FIELD] [% WARNING LEVEL] [WARN|ALERT]" && exit 0

[ -z "$1" ] && _sensor_name="mem" || _sensor_name="mem_"$1

[ -z "$2" ] && _mem_field="MemFree:" || _mem_field=$2":"
[ -z "$3" ] && _mem_level="80" || _mem_level=$3
[ "$4" == "FAIL" ] && _mem_sts="FAIL" || _mem_sts="MARK"

_sensor_status=$( awk -v _mf="$_mem_field" -v _msts="$_mem_sts" -v _mlvl="$_mem_level" '
	$1 == "MemTotal:" { 
		_mtd=int($2)
	} $1 == _mf { 
		_mfd=int($2)
	} END { 
		if ( _mfd == "" ) {
			_status="DISABLE zero"
		} else {
			_per=int((_mfd*100)/_mtd)
			if ( _per <= _mlvl ) { 
				_status=_msts" "_per"%"
			} else {
				_status="UP "_per"%"
			}
		}
		if ( _status == "" ) { 
			print "DISABLE no data"
		} else {
			print _status
		}
	}' /proc/meminfo )

echo $_sensor_name":"$_sensor_status"@"
