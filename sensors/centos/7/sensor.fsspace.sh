#!/bin/bash

[ "$1" == "help" ] && echo "HELP: filesystem space sensor help, options: [NAME] [FS] [THERSHOLD_DOWN] [THERSHOLD_UP] [ALERT|WARN]" && exit 0

_sensor_name="disk_space"
_sensor_status="CHECKING"

[ -z "$2" ] && _fs="" || _fs=$2
[ -z "$3" ] && _thdown=70 || _thdown=$3
[ -z "$4" ] && _thup=85 || _thup=$4
[ "$4" == "ALERT" ] && _status="FAIL" || _status="MARK"

_space=$( df -l $_fs | awk -v _st="$_status" -v _thd="$_thdown" -v _thu="$_thup" -v _fs="$_fs" '
        BEGIN {
                _s="CHECK"
        } $(NF-1) ~ "[0-9]" {
                gsub(/%/,"",$(NF-1)) ;
                $(NF-1)=int($(NF-1)) ;
                if ( $(NF-1) < _thd ) {
                        _s="UP"
                        if ( _fs != "" ) { _out=$(NF-1)"%" }
                }
                if ( $(NF-1) > _thd && $(NF-1) < _thu ) {
                        if ( _fs == "" ) {
                                _out=_out""$NF" "$(NF-1)"% "
                        } else {
                                _out=$(NF-1)"%"
                        }
                        if ( _s != "FAIL" ) { _s="MARK" }
                }
                if ( $(NF-1) >= _thu ) {
                        if ( _fs == "" ) {
                                _out=_out""$NF" "$(NF-1)"% " ;
                        } else {
                                _out=$(NF-1)"%"
                        }
                        _s=_st
                }
        } END {
                print _s" "_out
        }' | tr -d '\n' )

[ -z "$_space" ] && _sensor_status="MARK sens fail" || _sensor_status=$_space

echo $_sensor_name":"$_sensor_status"@"
