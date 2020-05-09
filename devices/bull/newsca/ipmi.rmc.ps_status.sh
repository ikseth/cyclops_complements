#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="PS_[1-4][1-4] Status"

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" 'BEGIN { _status="ok" } $1 ~ _test && $2 !~ "na" { if ( $4 !~ "0x0100$" ) { _status="down";  _ps_st=$1; gsub(/ Status/,"",_ps_st); _ps=_ps" "_ps_st } } END { print _status""_ps }' ) 

case "$_sensor_output" in
	"ok")
	_sensor_status="OK ok"
	;;
	down*)
	_sensor_status="DOWN"$( echo $_sensor_output | sed 's/down//' | tr '[:upper:]' '[:lower:]' ) 
	;;
	*)
		#_sensor_status=$( echo "${_sensor_output}" | awk -F\| -v _test="$_sensor_string" '$1 ~ _test && $4 !~ "ok" { print $1" "; printf ("%d",$2) ; print "c" }' )
		_sensor_status="UNKN ($_sensor_output)"
	;;
esac

echo $_sensor_string":"$_sensor_status
