#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="HYB_1 Outlet Pr"

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" '$1 ~ _test { _t=(($2-$6) * 100) / ($8-$6) ; gsub(/\.[0-9]+$/,"",_t) ; print _t }' )

case "$_sensor_output" in
        "-"[0-9]*|0|10[1-9]|1[1-9][0-9])
                _sensor_status="DOWN $_sensor_output%"
        ;;
        [1-9]|100)
                _sensor_status="FAIL $_sensor_output%"
        ;;
        1[0-9]|9[0-9])
                _sensor_status="MARK $_sensor_output%"
        ;;
        [2-8][0-9])
                _sensor_status="UP $_sensor_output%"
        ;;
        "")
                _sensor_status="DISABLE sensor miss"
        ;;
        *)
                _sensor_status="UNKNOWN $_sensor_output"
        ;;
esac

echo $_sensor_string":"$_sensor_status
