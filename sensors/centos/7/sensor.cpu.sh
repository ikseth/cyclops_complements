#!/bin/bash

[ "$1" == "help" ] && echo "HELP: CPU use sensor. sysstats dependecy" && exit 0

_sensor_name="cpu"
_sensor_status="CHECKING"

_sensor__cmd=$( which mptstat 2>/dev/null )

if [ -z "$_sensor_cmd" ]
then
  _sensor_status="DISABLE no cmd"
else
  _cpu=$( $_sensor_cmd 2 2 | awk '$1 ~ "^[a-zA-z]*:" { print $NF }' | sed 's/\...$//')

  let _cpu=100-$_cpu

  if [ -z "$_cpu" ]
  then
          _sensor_status="MARK sensor err"
  else
        case "$_cpu" in
                [0-9]|[1-4][0-9])
                        _sensor_status="UP $_cpu%"
                ;;
                [5-6][0-9])
                        _sensor_status="OK $_cpu%"
                ;;
                100|[7-9][0-9])
                        _sensor_status="CHECKING $_cpu%"
                ;;
                *)
                        _sensor_status="UNKNOWN"
                ;;
         esac
  fi
fi

echo $_sensor_name":"$_sensor_status"@"
