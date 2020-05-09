#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_apc_output' to get data to process

_sensor_string="APC Status"

_sensor_output=$( echo "${_sensor_apc_output}" | awk -F" : " '{ gsub(/ +$/,"",$1) ; gsub(/^ +/,"",$2) ; gsub(/ +$/,"",$2) } $1 == "STATUS" { print $2 }' )

sleep 1s

case "$_sensor_output" in
        ONLINE)
                _sensor_status="OK $_sensor_output"
        ;;
        *)
        _sensor_status="UNKNOWN $_sensor_output"
        ;;
esac

echo $_sensor_string":"$_sensor_status
