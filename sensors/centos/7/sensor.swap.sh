#!/bin/bash

[ "$1" == "help" ] && echo "HELP: Swap sensor" && exit 0

_sensor_name="swap"
_sensor_status="CHECKING"

_sensor_cmd_vm=$( which vmstat 2>/dev/null )
_sensor_cmd_so=$( which swapon 2>/dev/null )

if [ -z "$_sensor_cmd_vm" ] || [ -z "$_sensor_cmd_so" ]
then
  _sensor_status="DISABLE no cmd"
else
  _swp=$( $_sensor_cmd_vm | awk '{ print $3 }' | tail -n 1 )
  _space=$( $_sensor_cmd_so -s | tail -n 1 | awk '{ print $3}' )
  let _total=($_swp*100)/$_space

  case "$_total" in
        [0-5])
                _sensor_status="UP"
        ;;
        [5-9])
                _sensor_status="OK $_total%"
        ;;
        [1-4][0-9])
                _sensor_status="FAIL $_total%"
        ;;
        [5-9][0-9]|100)
                sensor_status="DOWN $_total%"
        ;;
        *)
                sensor_status="UNKNOWN"
        ;;
  esac
fi

echo $_sensor_name":"$_sensor_status"@"
