#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

[ $1 == "help" ] && echo "HELP: sensor options: [SENSOR NAME] [STORAGE DEVICE]" >&2 && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

_stg_dev="/dev/$2"

_sdatemp=$( smartctl --all $_stg_dev | awk '$1 == "194" && $NF ~ "/"{ _temp=$(NF-2) ; gsub(")$","",$NF) ; split($NF,a,"/")  ; _per=((_temp-a[1])*100)/(a[2]-a[1]) ; split(_per,b,".") ; print b[1] }' )

case "$_sdatemp" in
	"-"[0-9])
		_sensor_status="MARK min"
	;;
	[0-6][0-9])
		_sensor_status="UP $_sdatemp%"
	;;
	[7-9][0-9])
		_sensor_status="OK $_sdatemp%"
	;;
	[1-9][0-9][0-9])
		_sensor_status="MARK $_sdatemp%"
	;;
	"")
	_sensor_status="DISABLE sensor miss"
	;;
	*)
	_sensor_status="UNKNOWN $_sdatemp"
	;;
esac

echo $_sensor_name":"$_sensor_status"@"

