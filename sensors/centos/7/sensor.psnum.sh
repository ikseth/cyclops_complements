#!/bin/bash

[ "$1" == "help" ] && echo "HELP: sensor help, options: [NAME] [USER] [PSNAME] [ALERT|WARN] [THRESHOLD] [UP|DOWN]" && exit 0
[ "$4" == "ALERT" ] && _status="FAIL" || _status="MARK"
[ -z "$5" ] && _th=30 || _th=$5
[ "$6" == "DOWN" ] && _thctrl="DOWN" ||_thctrl="UP"

_sensor_name=$1
_sensor_status="CHECKING"

_sensor_status=$( ps -eFl | awk -v _usr="$2" -v _ps="$3" -v _st="$_status" -v _th="$_th" -v _thc="$_thctrl" '
        BEGIN {
                _c=0
        } _usr == $3 {
                for (f=17;f<=NF;f++) {
                        if ( $f ~ _ps ) { _c++ ; break }
                }
        } END {
                if ( _thc == "DOWN" ) {
                        if ( _c <= _th ) {
                                _msg="UP "_c
                        } else {
                                _msg=_st" "_c
                        }
                }
                if ( _thc == "UP" ) {
                        if ( _c >= _th ) {
                                _msg="UP "_c
                        } else {
                                _msg=_st" "_c
                        }
                }
                print _msg
        }' )

echo $_sensor_name":"$_sensor_status"@"
