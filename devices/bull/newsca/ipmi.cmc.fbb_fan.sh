#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="FBB_[0-9] [AB] Speed"

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" 'BEGIN { _status="ok" }  $1 ~ _test { if ( $4 !~ "ok" ) { print $0 ; _status="down"} } END { print _status }' ) 

case "$_sensor_output" in
	ok)
	_sensor_status="UP"
	;;
	*)
	_sensor_status=$( echo "${_sensor_output}" | awk -F\| -v _test="$_sensor_string" '$1 ~ _test && $4 !~ "ok" { print $1" "; printf ("%d",$2) ; print ""}' )
	;;
esac

echo $_sensor_string":"$_sensor_status
