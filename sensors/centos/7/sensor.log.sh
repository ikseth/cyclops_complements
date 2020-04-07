#!/bin/bash

[ "$1" == "help" ] && echo "HELP: sensor options: [SENSOR NAME] [LOGDIR] [LOGFILE] [WARN|FAIL] [TMPFILE] [TYPE MSG] [STRING1,STRING2,...]" && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

source /etc/cyclops/global.cfg ## OWN EXEC ##

[ -z "$2" ] && _logdir="/var/log" || _logdir=$2
[ -z "$3" ] && _logfile="messages" || _logfile=$3
[ "$4" == "FAIL" ] && _snsmsg="FAIL" || _snsmsg="WARN"
[ -z "$5" ] && _logtmp_file="/tmp/logtmt.cyc" || _logtmp_file=$5
[ -z "$7" ] && _logstr="error" || _logstr=$7
_logty=$6

if [ -f "$_logtmp_file" ] && [ -f "$_logdir/$_logfile" ] 
then
        _time_thr=$( stat -c %Z $_logtmp_file )
        _sensor_status=$( awk -v _tr="$_time_thr" -v _sm="$_snsmsg" -v _ls="$_logstr" -v _lt="$_logty" '
                BEGIN { 
                        _now=systime() ; 
                        _ny=strftime("%Y",_now)
                        _st="UP" ;
                        _ns=split(_ls,s,",") 
                        _err=0 
                } {
                        if ( $1 ~ "^[0-9]+$" ) { 
                                _ts=$1
                        } else {
                                split($3,t,":")
                                gsub("Jan","01",$1)
                                gsub("Feb","02",$1)
                                gsub("Mar","03",$1)
                                gsub("Apr","04",$1)
                                gsub("May","05",$1)
                                gsub("Jun","06",$1)
                                gsub("Jul","07",$1)
                                gsub("Aug","08",$1)
                                gsub("Sep","09",$1)
                                gsub("Oct","10",$1)
                                gsub("Nov","11",$1)
                                gsub("Dec","12",$1)
                                _ts=mktime( _ny" "$1" "$2" "t[1]" "t[2]" "t[3] )
                        }
                } _ts > _tr && _ts < _now && $5 ~ _lt { 
                        for (i=1;i<=_ns;i++) {
                                if ( $0 ~ s[i] ) {
                                        _err++ ; 
                                }
                        }
                } END { 
                        if ( _err == "0" ) { _st="UP" ; _err="" } else { _st=_sm }
                        print _st" "_err 
                }' $_logdir/$_logfile )
else

        [ ! -f "$_logtmp_file" ] && _sensor_status="DISABLE notime"
        [ ! -f "$_logdir/$_logfile" ] && _sensor_status="MARK nolog"
fi

echo $( date +%s ) > $_logtmp_file

echo $_sensor_name":"$_sensor_status"@"
