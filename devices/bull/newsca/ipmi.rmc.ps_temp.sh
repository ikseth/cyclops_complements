#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="PS_[0-9][0-9] Temp"

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" '$1 ~ _test && $2 !~ "na" { _value = $2 * 100 / $9 ; _suma = _suma + _value ; _lines++ } END { _suma = _suma / _lines ; printf ("%d", _suma) ; print "" }' ) 

case "$_sensor_output" in
        [0-9]|[1-7][0-9])
                _sensor_status="UP $_sensor_output%"
        ;;
        8[0-9])
                _sensor_status="OK $_sensor_output%"
        ;;
        100|9[0-9])
        _sensor_status="DOWN $_sensor_output%"
        ;;
        "")
        _sensor_status="DISABLE sensor miss"
        ;;
        *)
        _sensor_status="UNKNOWN $_sensor_output"
        ;;
esac

echo $_sensor_string":"$_sensor_status
