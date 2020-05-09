#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="IBSW_1"

_sensor_output=$( echo "${_sensor_ipmi_output}" | sed -e 's/ //g' | awk -F\| -v _test="$_sensor_string" '$1 == _test { print $4 }' )

case "$_sensor_output" in
0x0200)
	_sensor_status="UP"
;;
"")
	_sensor_status="DISABLE no data"
;;
*)
	_sensor_status="UNKNOWN($_sensor_output)"
;;
esac

echo $_sensor_string":"$_sensor_status
