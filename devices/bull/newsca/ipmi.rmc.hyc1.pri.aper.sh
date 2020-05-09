#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="HYB_1 Pri Aper."

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" '$1 ~ _test { print $2 + 0 }' | cut -d'.' -f1 )

case "$_sensor_output" in
	0)
		_sensor_status="DOWN $_sensor_output%"
	;;
        [1-9])
                _sensor_status="MARK $_sensor_output%"
        ;;
        [1-5][0-9])
                _sensor_status="UP $_sensor_output%"
        ;;
	[6-7][0-9])
		_sensor_status="OK $_sensor_output%"
	;;
        8[0-9]|9[0-5])
	        _sensor_status="MARK $_sensor_output%"
        ;;
	9[6-9]|100)
	        _sensor_status="MARK $_sensor_output%"
	;;
        "")
		_sensor_status="DISABLE sensor miss"
        ;;
        *)
        	_sensor_status="UNKN ($_sensor_output)"
        ;;
esac

echo $_sensor_string":"$_sensor_status
