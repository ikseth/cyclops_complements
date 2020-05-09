#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="HYB_[12] Tenant"

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" '$1 ~ _test && $4 ~ "0x0200" { print $1 }' | sed -e 's/HYB_\([1-2]\)\ Tenant\ */hyc\1/' )

case "$_sensor_output" in
hyc1)
	_sensor_status="OK $_sensor_output"
;;
hyc2)
	_sensor_status="UP $_sensor_output"
;;
"")
	_sensor_status="DOWN"
;;
*)
	_sensor_status="UNKNOWN($_sensor_output)"
;;
esac

echo $_sensor_string":"$_sensor_status
