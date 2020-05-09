#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="Pwr Consumption"

_sensor_output=$( echo "${_sensor_ipmi_output}" | grep "^$_sensor_string" | awk -F\| '{ print $4 }' | sed 's/ //g' )

case "$_sensor_output" in
ok)
	_sensor_status="OK ok"
;;
*)
	_sensor_status="UNKNOWN($_sensor_output)"
;;
esac

echo $_sensor_string":"$_sensor_status
