#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="PDM_1"

_sensor_output=$( echo "${_sensor_ipmi_output}" | tr '|' ';' | sed -e 's/ *;/;/g' -e 's/; */;/g' | awk -F\; -v _test="$_sensor_string" '$1 == _test { print $4 }' | sed 's/ //g' )

case "$_sensor_output" in
0x0200)
	_sensor_status="UP"
;;
0x0100) 
	_sensor_status="DOWN fail"
;;
*)
	_sensor_status="UNKNOWN($_sensor_output)"
;;
esac

echo $_sensor_string":"$_sensor_status
