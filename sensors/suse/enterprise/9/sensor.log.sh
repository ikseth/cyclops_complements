#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

[ "$1" == "help" ] && echo "HELP: sensor options: [SENSOR NAME] [LOGDIR] [LOGFILE] [WARN|FAIL] [ALERT VALUE] [TMPFILE] [TYPE MSG] [STRING1,STRING2,...]" && exit 0

[ -z "$1" ] && _sensor_name="log" || _sensor_name="log_"$1
_sensor_status="CHECKING"

[ -z "$2" ] && _logdir="/var/log" || _logdir=$2
[ -z "$3" ] && _logfile="messages" || _logfile=$3
[ "$4" == "FAIL" ] && _snsmsg="FAIL" || _snsmsg="MARK"
[ -z "$5" ] && _maxvalue=0 || _maxvalue=$5
[ -z "$6" ] && _logtmp_file="/tmp/logtmt.cyc" || _logtmp_file=$6
_logty=$7
[ -z "$8" ] && _logstr="error" || _logstr=$8

if [ -f "$_logtmp_file" ] && [ -f "$_logdir/$_logfile" ] 
then
	_time_thr=$( stat -c %Z $_logtmp_file )
	_sensor_status=$( awk -v _tr="$_time_thr" -v _sm="$_snsmsg" -v _ls="$_logstr" -v _lt="$_logty" -v _mv="$_maxvalue" '
		BEGIN { 
			_now=systime() ; 
			_ny=strftime("%Y",_now)
			_st="UP" ;
			_ns=split(_ls,s,",") 
			_err=0 
		} {
			if ( $1 ~ "^[0-9.]+$" ) { 
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
			if ( _err > _mv ) { _st=_sm } else { _st="UP" }
			print _st" "_err 
		}' $_logdir/$_logfile )
else
	
	[ ! -f "$_logtmp_file" ] && _sensor_status="DISABLE notime"
	[ ! -f "$_logdir/$_logfile" ] && _sensor_status="MARK nolog"	
fi

echo $( date +%s ) > $_logtmp_file


echo $_sensor_name":"$_sensor_status"@"
