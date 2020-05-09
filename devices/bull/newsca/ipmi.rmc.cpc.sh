#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="CPC functional"

_sensor_output=$( echo "${_sensor_ipmi_output}" | grep "^$_sensor_string" | awk -F\| '{ print $4 }' | sed 's/ //g' )

case "$_sensor_output" in
0x0100)
	_sensor_status="OK ok"
;;
0x0200)
	_sensor_status="MARK warning"
;;
0x0300)
	_sensor_status="FAIL critical"
;;
0x0400) 
	_sensor_status="DOWN non-recov"
;;
0x1000)
	_sensor_status="DOWN psu"
;;
na)
	_sensor_status="MARK no data"
;;
*)
	_sensor_status="UNKNOWN($_sensor_output)"
;;
esac

echo $_sensor_string":"$_sensor_status
