#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="HYB_1 Pri Aper."

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" '$1 ~ _test { print $2 }' | cut -d'.' -f1 )

case "$_sensor_output" in
	0)
		_sensor_status="DOWN $_sensor_output%"
	;;
        [1-9]|1[0-9])
                _sensor_status="MARK $_sensor_output%"
        ;;
        [2-6][0-9])
                _sensor_status="UP $_sensor_output%"
        ;;
	[7-8][0-9])
		_sensor_status="OK $_sensor_output%"
	;;
        100|9[0-9])
	        _sensor_status="MARK $_sensor_output%"
        ;;
        "")
		_sensor_status="DISABLE sensor miss"
        ;;
        *)
        	_sensor_status="UNKNOWN $_sensor_output"
        ;;
esac

echo $_sensor_string":"$_sensor_status
