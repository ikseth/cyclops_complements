#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="DBB_[0-9] Speed"

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" 'BEGIN { _status="OK" }  $1 ~ _test { if ( $4 !~ "ok" ) { print $0 ; _status="FAIL"} } END { print _status }' ) 

case "$_sensor_output" in
	OK)
	_sensor_status="UP"
	;;
	*)
	_sensor_status=$( echo "${_sensor_output}" | awk -F\| -v _test="$_sensor_string" -v _status="$_sensor_output" 'BEGIN { _out="MARK" } $1 ~ _test && $4 !~ "ok" { split($1,a," ") ; _out=_out" "a[1] } END { print _out }' )
	;;
esac

echo $_sensor_string":"$_sensor_status
