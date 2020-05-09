#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string1="Blade_[1-9]$"
_sensor_string2="Blade_1[0-9]$"

_sensor_output=$( echo "${_sensor_ipmi_output}" | sed -e 's/ //g' | awk -F\| -v _test1="$_sensor_string1" -v _test2="$_sensor_string2" 'BEGIN { _status="ok" }  $1 ~ _test1 { if ( $4 != "0x0200" ) { _status="down"} } END { print _status }' ) 

case "$_sensor_output" in
	ok)
	_sensor_status="UP"
	;;
	down)
	_sensor_status="MARK a blade miss"
	;;
	*)
	_sensor_status="UNKNOWN "$( echo "${_sensor_output}" | awk -F\| -v _test1="$_sensor_string" -v test2="$_sensor_string" '$1 ~ _test1 || $1 ~ _test2 && $4 != "0x0200" { print $1" ("$2")" }' )
	;;
esac

echo $_sensor_string":"$_sensor_status
