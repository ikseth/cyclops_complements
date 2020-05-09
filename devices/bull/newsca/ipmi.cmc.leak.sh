#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="Leakage Alarm"

_sensor_output=$( echo "${_sensor_ipmi_output}" | grep "^$_sensor_string" | awk -F\| '{ print $4 }' | sed 's/ //g' )

case "$_sensor_output" in
*0x0100)
	_sensor_status="UP"
;;
*)
	_sensor_status="UNKNOWN($_sensor_output)"
;;
esac

echo $_sensor_string":"$_sensor_status
