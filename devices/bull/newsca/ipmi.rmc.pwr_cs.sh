#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="Pwr Consumption"

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _str="$_sensor_string" '$1 ~ _str { split($2,w,".") ; print w[1] }' | sed 's/ //g' )

case "$_sensor_output" in
[0-9]*)
	_sensor_status="UP "$_sensor_output
;;
"")
	_sensor_status="DISABLE off"
;;
*)
	_sensor_status="UNKNOWN($_sensor_output)"
;;
esac

echo $_sensor_string":"$_sensor_status
